# frozen_string_literal: true

require 'set'
require_relative 'proxy/constraints'
require_relative 'proxy/memos'
require_relative 'proxy/validations'
require_relative 'proxy/mixin'
module Lab42
  module DataClass
    class Proxy
      include Constraints, Memos, Validations

      attr_reader :actual_params, :block, :klass

      def check!(**params)
        @actual_params = params
        raise ArgumentError, "missing initializers for #{_missing_initializers}" unless _missing_initializers.empty?
        raise ArgumentError, "illegal initializers #{_illegal_initializers}" unless _illegal_initializers.empty?

        _check_constraints!(defaults.merge(params))
      end

      def define_class!
        klass.module_eval(&_define_attr_reader)
        klass.module_eval(&_define_initializer)
        _define_methods
        klass.include(Mixin)
        klass.module_eval(&block) if block
        klass
      end

      def init(data_class, **params)
        _init(data_class, defaults.merge(params))
      end

      def to_hash(data_class_instance)
        members
          .map { [_1, data_class_instance.instance_variable_get("@#{_1}")] }
          .to_h
      end

      private
      def initialize(*args, **kwds, &blk)
        @klass = if Class === args.first
                   args.shift
                 else
                   Class.new
                 end

        @block = blk
        defaults.update(kwds)
        positionals.push(*args)
      end

      def _define_attr_reader
        proxy = self
        ->(*) do
          attr_reader(*proxy.members)
        end
      end

      def _define_freezing_constructor
        ->(*) do
          define_method :new do |*a, **p, &b|
            super(*a, **p, &b).freeze
          end
        end
      end

      def _define_initializer
        proxy = self
        ->(*) do
          define_method :initialize do |**params|
            proxy.check!(**params)
            proxy.init(self, **params)
            proxy.validate!(self)
          end
        end
      end

      def _define_merge
        ->(*) do
          define_method :merge do |**params|
            values = to_h.merge(params)
            self.class.new(**values)
          end
        end
      end

      def _define_methods
        class << klass; self end
          .tap { |singleton| _define_singleton_methods(singleton) }
        klass.module_eval(&_define_to_h)
        klass.module_eval(&_define_merge)
      end

      def _define_singleton_methods(singleton)
        singleton.module_eval(&_define_freezing_constructor)
        singleton.module_eval(&_define_to_proc)
        singleton.module_eval(&_define_with_constraint)
        singleton.module_eval(&_define_with_validations)
      end

      def _define_to_h
        proxy = self
        ->(*) do
          define_method :to_h do
            proxy.to_hash(self)
          end
          alias_method :to_hash, :to_h
        end
      end

      def _define_to_proc
        ->(*) do
          define_method :to_proc do
            ->(other) { self === other }
          end
        end
      end

      def _init(data_class_instance, params)
        params.each do |key, value|
          data_class_instance.instance_variable_set("@#{key}", value)
        end
      end
    end
  end
end
#  SPDX-License-Identifier: Apache-2.0

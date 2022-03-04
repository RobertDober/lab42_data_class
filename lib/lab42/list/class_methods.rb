# frozen_string_literal: true

module Lab42
  class List
    module ClassMethods
      def cons(element, list)
        raise ArgumentError, "list needs to be a list instance" unless list?(list)

        allocate.tap do |o|
          o.instance_variable_set("@car", element)
          o.instance_variable_set("@cdr", list)
          o.instance_variable_set("@length", list.length.succ)
          o.freeze
        end
      end

      def each(subject, &blk)
        unless subject.empty?
          blk.(subject.car)
          each(subject.cdr, &blk)
        end
      end

      def list?(subject)
        self === subject || Nil == subject
      end

      def new(*elements)
        elements.reverse.inject(Nil) do |list, element|
          cons(element, list)
        end
      end
    end
    extend ClassMethods
  end
end
# SPDX-License-Identifier: Apache-2.0

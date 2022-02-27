# frozen_string_literal: true

module Lab42
  module DataClass
    class Proxy
      module Derived
        private
        def _define_derived
          proxy = self
          ->(*) do
            define_method :derive do |att_name, &blk|
              proxy.define_derived_attribute(att_name, &blk)
              self
            end
          end
        end
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0

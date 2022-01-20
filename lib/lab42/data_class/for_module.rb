# frozen_string_literal: true

require_relative 'proxy'

module Lab42
  module DataClass
    class ::Module
      def dataclass(*args, **defaults)
        proxy = Lab42::DataClass::Proxy.new(*args, __klass__: self, **defaults)
        proxy.define_class!
      end
    end
  end
end
#  SPDX-License-Identifier: Apache-2.0

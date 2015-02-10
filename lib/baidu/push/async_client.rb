require 'celluloid'

module Baidu
  module Push
    class AsyncClient < Client
      include Celluloid
    end
  end
end
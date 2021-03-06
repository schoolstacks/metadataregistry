require 'exceptions'
require 'v1/defaults'
require 'v1/envelopes'
require 'render_markdown'

module API
  module V1
    # Home page
    class Home < Grape::API
      prefix '' # reset prefix from `/api/` to `/`

      # return HTML instead of json
      content_type :html, 'text/html'
      format :html

      desc 'Homepage'
      get do
        RenderMarkdown.new('README').to_html
      end
    end
  end
end

module KeywordManager
  # Returns JSON data from page
  # Returns false if
  class GetJsonFromOnePageService < ApplicationService
    def initialize(page_url)
      @page_url = page_url.strip
    end

    def call
      return Failure.new(err_code: :empty_url, message: 'URL is empty') if @page_url.empty?

      begin
        resp = Net::HTTP.get_response(URI.parse(@page_url))
        page = JSON.parse(resp.body)
        return Failure.new(err_code: :response_error, message: page['data']['errorMsg']) if page['state'] == -1

        result = Success.new(products: page['data']['products'], pager: page['data']['pager'])
      rescue StandardError => e
        result = Failure.new(err_code: :net_error, message: e)
      end

      result
    end
  end
end

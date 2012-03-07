module Lumberg
  class FormatWhm < Faraday::Response::Middleware
    
    def initialize(env, *args, &block)
      @type = args[0]
      @key = args[1]
      @boolean_params = args[2]
      super(env)
    end

    def on_complete(env)
      env[:body] = format_response(env[:body])
    end

    def response_values(env)
      {:status => env[:status], :headers => env[:response_headers], :body => env[:body]}
    end
    
  private
    
    def format_response(response)
      success, message, params = false, nil, {}

      case @type || response_type(response)
        when :action
          success, message, params = format_action_response(response)
        when :query
          success, message, params = format_query_response(response)
        when :error
          message = response['error']
        when :unknown
          message = "Unknown error occurred #{response.inspect}"
      end
      
      params = Whm::symbolize_keys(params)
      params = Whm::to_bool(params, @boolean_params)

      {:success => success, :message => message, :params => params}
    end
    
    def response_type(response)
      if !response.respond_to?(:has_key?)
        :unknown
      elsif response.has_key?('error')
        :error
      elsif response.has_key?(@key)
        :action
      elsif response.has_key?('status') && response.has_key?('statusmsg')
        :query
      else
        :unknown
      end
    end

    def format_action_response(response)
      # Some API methods ALSO return a 'status' as
      # part of a result. We only use this value if it's
      # part of the results hash
      item = response[@key]
      unless item.is_a?(Array) || item.is_a?(Hash)
        res = {@key => item}
        success, message = true, ""
      else
        result = nil
        if item.first.is_a?(Hash)
          result = item.first
          res = (item.size > 1 ? item.dup : item.first.dup)
        else
          res = item.dup

          # more hacks for WHM silly API
          if response.has_key?('result')
            result_node = response['result']
            node_with_key_status = result_node.is_a?(Hash) && result_node.has_key?('status')
            result = (node_with_key_status ? result_node : result_node.first)
          else
            res.delete('status')
            res.delete('statusmsg')
          end
        end
        unless result.nil?
          success = result['status'].to_i == 1
          message = result['statusmsg']
        end
      end
      return success, message, res
    end

    def format_query_response(response)
      success = response['status'].to_i == 1
      message = response['statusmsg']

      # returns the rest as a params arg
      res = response.dup
      res.delete('status')
      res.delete('statusmsg')

      return success, message, res
    end

  end
end
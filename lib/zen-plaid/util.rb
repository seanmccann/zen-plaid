module Plaid
  module Util
    def self.objects_to_ids(h)
      case h
      when APIResource
        h.id
      when Hash
        res = {}
        h.each { |k, v| res[k] = objects_to_ids(v) unless v.nil? }
        res
      when Array
        h.map { |v| objects_to_ids(v) }
      else
        h
      end
    end

    def self.symbolize_names(object)
      case object
      when Hash
        new = {}
        object.each do |key, value|
          key = (key.to_sym rescue key) || key
          new[key] = symbolize_names(value)
        end
        new
      when Array
        object.map { |value| symbolize_names(value) }
      else
        object
      end
    end

    def self.url_encode(key)
      URI.escape(key.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end

    def self.flatten_params(params, parent_key=nil)
      result = []
      params.each do |key, value|
        calculated_key = parent_key ? "#{parent_key}[#{url_encode(key)}]" : url_encode(key)
        if value.is_a?(Hash)
          result += flatten_params(value, calculated_key)
        elsif value.is_a?(Array)
          result += flatten_params_array(value, calculated_key)
        else
          result << [calculated_key, value]
        end
      end
      result
    end

    def self.flatten_params_array(value, calculated_key)
      result = []
      value.each do |elem|
        if elem.is_a?(Hash)
          result += flatten_params(elem, calculated_key)
        elsif elem.is_a?(Array)
          result += flatten_params_array(elem, calculated_key)
        else
          result << ["#{calculated_key}[]", elem]
        end
      end
      result
    end

    def self.credentials_params(params)
      unless params.has_key?(:credentials)
        params[:credentials] = {}
        params[:credentials][:username] = params[:username] if params[:username]
        params[:credentials][:password] = params[:password] if params[:password]
        params[:credentials][:pin] = params[:pin] if params[:pin]
      end

      params.delete(:username)
      params.delete(:password)
      params.delete(:pin)

      params
    end
  end
end

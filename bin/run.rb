require_relative '../db/setup'
require_relative '../lib/all'
require 'pry'
# Remember to put the requires here for all the classes you write and want to use

def parse_params(uri_fragments, query_param_string)
  params = {}
  params[:resource]  = uri_fragments[3]
  params[:id]        = uri_fragments[4]
  params[:action]    = uri_fragments[5]
  if query_param_string
    param_pairs = query_param_string.split('&')
    param_k_v   = param_pairs.map { |param_pair| param_pair.split('=') }
    param_k_v.each do |k, v|
      params.store(k.to_sym, v)
    end
  end
  params
end
# You shouldn't need to touch anything in these methods.
def parse(raw_request)
  pieces = raw_request.split(' ')
  method = pieces[0]
  uri    = pieces[1]
  http_v = pieces[2]
  route, query_param_string = uri.split('?')
  uri_fragments = route.split('/')
  protocol = uri_fragments[0][0..-2]
  full_url = uri_fragments[2]
  subdomain, domain_name, tld = full_url.split('.')
  params = parse_params(uri_fragments, query_param_string)
  return {
    method: method,
    uri: uri,
    http_version: http_v,
    protocol: protocol,
    subdomain: subdomain,
    domain_name: domain_name,
    tld: tld,
    full_url: full_url,
    params: params
  }
end

system('clear')
loop do
  print "Supply a valid HTTP Request URL (h for help, q to quit) > "
  raw_request = gets.chomp

  case raw_request
  when 'q' then puts "Goodbye!"; exit
  when 'h'
    puts "A valid HTTP Request looks like:"
    puts "\t'GET http://localhost:3000/students HTTP/1.1'"
    puts "Read more at : http://www.w3.org/Protocols/rfc2616/rfc2616-sec5.html"
  else
    @request = parse(raw_request)
    @params  = @request[:params]
    binding.pry
    # Use the @request and @params instance variables to fill the request and
    # return an appropriate response
    # YOUR CODE GOES BELOW HERE
    resource_name = @params[:resource]
    resource_name = resource_name.slice(0..-2).capitalize
    error = resource_name.downcase
    resource_name = Object.const_get(resource_name)
    if @request[:method] == "DELETE"
      if !@params[:id].nil? && @params[:action].nil?
        begin
          @params_resources = User.find(@params[:id])
          puts "The user with id ##{@params_resources.id} named #{@params_resources.first_name} #{@params_resources.last_name}, age: #{@params_resources.age}, was destroyed"
          @params_resources.destroy
        rescue ActiveRecord::RecordNotFound
          puts "Error 404: There is no #{error} with those parameters."
        end
      end
    elsif @params.size > 3 && @request[:method] == "GET"
      if @params.has_key?(:first_name)
        @params_resources = User.where("first_name LIKE ?", "#{@params[:first_name]}%")
        @params_resources.each do |resource|
          puts "#{resource.id} - #{resource.first_name} #{resource.last_name}: #{resource.age}"
        end
      elsif @params.has_key?(:limit) && @params.has_key?(:offset)
        @params_resources = User.limit(10).offset(10)
        @params_resources.each do |resource|
          puts "#{resource.id} - #{resource.first_name} #{resource.last_name}: #{resource.age}"
        end
      end
    elsif !@params[:resource].nil?
      if @params[:id].nil? && @params[:action].nil?
        @resources = resource_name.all
        @resources.each do |resource|
          puts "#{resource.id} - #{resource.first_name} #{resource.last_name}: #{resource.age}"
        end
      elsif !@params[:id].nil? && @params[:action].nil?
        begin
          resource = resource_name.find(@params[:id])
          puts "#{resource.id} - #{resource.first_name} #{resource.last_name}: #{resource.age}"
        rescue ActiveRecord::RecordNotFound
          puts "Error 404: There is no #{error} with those parameters."
        end
      end
    end
    # YOUR CODE GOES ABOVE HERE  ^
  end
end




















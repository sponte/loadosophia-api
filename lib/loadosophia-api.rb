require 'loadosophia/api/version'
require 'loadosophia/api/object'
require 'net/http'
require 'json'

class LoadosophiaApi
	BASE_URI = URI.parse('https://loadosophia.org')

	def initialize(token, options = {})
		@token = token
		@http = Net::HTTP.new(BASE_URI.host, BASE_URI.port)
		@debug = options.delete(:debug)
		@http.set_debug_output $stderr if @debug

		if BASE_URI.scheme == "https"
			@http.use_ssl = true
		end
	end

	def project_groups
		get("/projectGroup/list/")
	end

	def projects(group_id)
		get "/projectGroup/projects/?PGroupID=#{group_id}&format=json"
	end

	def tests(project_id)
		get("/project/tests/#{project_id}/1/")
	end

	def test_info(test_id)
		get("/test/info/#{test_id}/")[0]
	end

	def trash
		get "/user/trashstate/"
	end

	def active_tests
		get "/active/list/"
	end

	def distributions(test_id)
		get "/test/data/#{test_id}/GroupsDist/"
	end
private

	def get(path, format='json')
		path = "/api#{path}"
		path += "?format=#{format}" unless path.include?('?')
		request = Net::HTTP::Get.new(path)
		request['X-Loadosophia-Token'] = @token
		body = @http.request(request).body
		$stderr.write "Received body for #{path}:\n#{body}" if @debug

		json = JSON.parse(body)

		if json.is_a?(Array)
			json.map do |a|
				Loadosophia::Api::Object.from a
			end
		else
			Loadosophia::Api::Object.from json
		end
	end
end

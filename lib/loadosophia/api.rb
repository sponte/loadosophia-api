require "loadosophia/api/version"
require "loadosophia/api/object"
require 'net/http'

module Loadosophia

	class Loadosophia
		BASE_URI = URI.parse('https://loadosophia.org')

		def initialize(token)
			@token = token
			@http = Net::HTTP.new(BASE_URI.host, BASE_URI.port)

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
			get("/test/info/#{test_id}/")
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
			Loadosophia::Api::Object.from JSON.parse(@http.request(request).body)
		end
	end
end

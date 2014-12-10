module Loadosophia
	module Api
		class Object
			def self.from(json)
				if json[1].size > 1
					json[1].map do |o|
						self.new(o)
					end
				else
					self.new(json[1][0])
				end
			end

			def initialize(data)
				@data = data
			end

			def method_missing(name, *args, &block)
				if @data.has_key?(name.to_s)
					@data[name.to_s]
				else
					super
				end
			end
		end
	end
end
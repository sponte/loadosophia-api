module Loadosophia
	module Api
		class Object
			def self.from(json)
				self.new(json)
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
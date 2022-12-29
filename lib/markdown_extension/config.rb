require "tomlrb"

module MarkdownExtension
    class Config
        attr_accessor :raw_config, :file, :type

        def load_file(file, type)
            @raw_config = begin
                Tomlrb.load_file(file)
            rescue
                {}
            end
        end

        def initialize(file, type)
            @file = file
            @type = type
            load_file(file , type)
            return self
        end

        def title
            if @raw_config
                if @raw_config[@type.to_s]
                    return @raw_config[@type.to_s]["title"]
                end
            end
            ""
        end

        def src
            if @raw_config
                if @raw_config[@type.to_s]
                    return @raw_config[@type.to_s]["src"]
                end
            end
            ""
        end

        def preprocessing
            if @raw_config
                return @raw_config["preprocessing"]
            end
        end

        def giscus
            if @raw_config
                return @raw_config["giscus"]
            end
        end
    end
end
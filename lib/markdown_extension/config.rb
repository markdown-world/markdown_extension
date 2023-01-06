require "tomlrb"

module MarkdownExtension
    class Config
        attr_accessor :raw_config, :file, :type

        def load_file(file)
            @raw_config = begin
                Tomlrb.load_file(file)
            rescue
                {}
            end
        end

        def initialize(file, type)
            @file = file
            @type = type
            load_file(file)
            return self
        end

        def get_base_info(name)
            if @raw_config
                if @raw_config[@type.to_s]
                    return @raw_config[@type.to_s][name]
                end
            end
            ""
        end

        def title
            get_base_info("title")
        end

        def src
            get_base_info("src")
        end

        def pages
            get_base_info("pages")
        end

        def journals
            get_base_info("journals")
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
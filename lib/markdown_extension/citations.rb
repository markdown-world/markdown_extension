module MarkdownExtension
    class Citations
        attr_accessor :config, :type, :inner_citations
        def initialize(config, type)
            @config = config
            @type = type
            @inner_citations = {}            
            if config.citation
                init_citation()
            end
        end

        def init_citation()
        end

        def add_inner_citation(file)
            text = File.read(file)
            lines = text.split("\n")[4..-1]
            if lines
                i = 0
                while(i < lines.size) do
                    content = lines[i][2..-1]
                    page_no = lines[i+2].split("hl-page:: ")[1]
                    id = lines[i+3].split("id:: ")[1]
                    @inner_citations[id] = "P#{page_no} #{content}"
                    i = i + 4
                end
            end            
        end

        def get_inner_citation(id)
            return @inner_citations[id]
        end
    end
end
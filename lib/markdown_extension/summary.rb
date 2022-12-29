require "kramdown"
require "kramdown-parser-gfm"

module MarkdownExtension
    class Summary
        attr_accessor :config, :markdown
        def initialize(config)
            @config = config
            file = config.src+"/summary.md"
            if File.exists?(file)
                @markdown = File.read(file)
            else
                @markdown = ""
            end
        end

        def pre_processing
            if @config.preprocessing["backlinks"]
                @markdown = @markdown.gsub(/\[\[(.*)\]\]/) do |s| 
                    s = s[2..-3]
                    "[#{s}](#{s}.html)"
                end
            end
        end

        def html
            pre_processing()
            return Kramdown::Document.new(@markdown, input: 'GFM').to_html            
        end
    end
end
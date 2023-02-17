require "kramdown"
require "kramdown-parser-gfm"

module MarkdownExtension
    class Summary
        attr_accessor :config, :raw_md, :markdown
        def initialize(config, lang=nil)
            @config = config
            if lang
                file = config.src+"/"+lang+"/summary.md"
            else
                file = config.src+"/summary.md"
            end
            if File.exist?(file)
                @raw_md = File.read(file)
            else
                @raw_md = ""
            end
        end

        def pre_processing(dir)
            @markdown = @raw_md
            if @config.preprocessing["backlinks"]
                @markdown = @markdown.gsub(/\[\[(.*)\]\]/) do |s| 
                    s = s[2..-3]
                    "[#{s}](#{s}.html)"
                end
            end
            unless dir.empty?
                @markdown = @markdown.gsub(/\[.*\]\((.*)\)/) do |s|
                    url = Regexp.last_match[1]
                    pn = Pathname.new(url)
                    s.gsub(url, "./"+pn.relative_path_from(dir+"/").to_s)
                end
            end
        end

        def html(dir=nil)
            pre_processing(dir)
            return Kramdown::Document.new(@markdown, input: 'GFM').to_html            
        end
    end
end
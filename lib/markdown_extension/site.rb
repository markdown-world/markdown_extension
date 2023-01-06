require "json"

module MarkdownExtension
    class Site
        attr_accessor :config, :summary, :pages, :journals, :references, :reverse_references
        attr_accessor :nodes, :links

        def initialize(config, type)
            @config = MarkdownExtension::Config.new(config, type)
            unless type == :logseq
                @summary = MarkdownExtension::Summary.new(@config)
            end
            @references = {}
            @reverse_references = {}
            @nodes = []
            @links = []
            load_source_files()
            gen_nodes_links()
        end

        def load_source_files
            @pages = []
            @journals = []
            if @config
                if @config.type == :logseq
                    journal_files = Dir.glob(@config.journals + "/*.md")
                    journal_files.each do |file|
                        page = MarkdownExtension::Page.new(file, self)
                        @journals << page
                    end
                    pages_path = @config.pages
                else
                    pages_path = @config.src
                end
                files = Dir.glob(pages_path + "/*.md")
                files.each do |file|
                    unless file == @config.pages + "/summary.md"
                        page = MarkdownExtension::Page.new(file, self)
                        @pages << page
                        gen_references(file , page.markdown)
                    end
                end
            end
        end

        def gen_references(file, text)
            text.gsub(/\[\[([^\]]+)\]\]/) do |s|
                s = s[2..-3]
                item_name = file.split("/")[-1].gsub(".md","")
                if @references[s]
                    @references[s] << item_name
                else
                    @references[s] = [item_name]
                end
                if @reverse_references[item_name]
                    @reverse_references[item_name] << s
                else
                    @reverse_references[item_name] = [s]
                end
            end
        end

        def gen_nodes_links
            @references.each do |k,v|
                @nodes << {
                    "id" => k,
                    "name" => k,
                    "color" => "blue",
                    "val" => @reverse_references[k] ? @reverse_references[k].size+1 : 1
                }
                v.each do |item|
                    @nodes << {
                        "id" => item,
                        "name" => item,    
                        "color" => "blue",
                        "val" => @reverse_references[item] ? @reverse_references[item].size+1 : 1
                    }
                    @links << {
                        "source" => item,
                        "target" => k
                    }
                end
            end
            @nodes = @nodes.uniq
            @links = @links.uniq
        end

        def write_data_json(file)
            data = {"nodes"=>@nodes, "links"=>@links}
            f = File.new(file, "w")
            f.puts JSON.generate(data)
            f.close
        end
    end
end
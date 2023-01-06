require "kramdown"
require "kramdown-parser-gfm"
require "tomlrb"

module MarkdownExtension
    class Page
        attr_accessor :site, :markdown, :meta, :item_name

        def initialize(file, site)
            @site = site
            if File.exists?(file)
                @markdown = File.read(file)
            else
                @markdown = ""
            end
            if @markdown.start_with?("---\n")
                mds = @markdown.split("---\n")
                @meta = mds[1]
                @markdown = mds[2..-1].join("---\n")
            end
            if @site.config.type == :logseq
                @markdown.gsub!(/\t/, "    ")
                if @markdown[-1]=="-"
                    @markdown = @markdown[0..-2]
                end
                @markdown.gsub!(/(.+)collapsed:: true\n/, "")
                @markdown = @markdown.gsub(/.+(- )[0-9]+\./) do |s|
                    s.gsub("- ","")
                end
                while (i = @markdown.index(":LOGBOOK:")) do 
                    j = @markdown.index(":END:", i)
                    @markdown=@markdown[0..i-4] + @markdown[j+5..-1]
                end
            end
            @item_name = file.split("/")[-1].gsub(".md","")
        end

        def pre_processing
            if @site.config.preprocessing["backlinks"]
                @markdown = @markdown.gsub(/\[\[([^\]]+)\]\]/) do |s|
                    index = @markdown.index(s)
                    if (@markdown[index-1]=="(" && @markdown[index+s.size]==")")
                        s = s[2..-3]
                        "#{s}.html"
                    else
                        s = s[2..-3]
                        "[#{s}](#{s}.html)"
                    end
                end
                if @site.references[@item_name]
                    @markdown += "\n\n\n"
                    @markdown += "### References\n"
                    @site.references[@item_name].each do |item|
                        @markdown += "* [#{item}](#{item}.html)\n"
                    end
                end
            end
        end

        def html
            pre_processing()
            @page_html = Kramdown::Document.new(@markdown, input: 'GFM').to_html
            return @page_html
        end

        def meta_html
            meta_data = Tomlrb.parse(@meta)
            html = ""
            meta_data.each do |title, values|
                html += "<p class=\"text-center bg-primary font-size-14\">"+title+"</p>\n"
                html += "<table class=\"table font-size-12\">\n"
                values.each do |key, value|
                    html += "<tr>\n"
                    if value.class == String
                        html += "<td>"+key + "</td><td>" + value.to_s + "</td>\n"
                    elsif value.class == Array
                        html += "<td>"+key + "</td><td>" + value.join("<br />") + "</td>\n"
                    elsif value.class == Hash
                        values = ""
                        value.each do |k,v|
                            values += k+": "+v+"<br />"
                        end
                        html += "<td>"+key + "</td><td>" + values + "</td>\n"
                    end
                    html += "</tr>\n"
                end
                html += "</table>\n"
            end
            return html
        end
    end
end
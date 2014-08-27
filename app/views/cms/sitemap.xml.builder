xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  @urls.each do |url|
    xml.url do
      xml.loc url[:url]
      xml.lastmod url[:last_modified]
      xml.changefreq url[:change_frequency]
      xml.priority url[:priority]
    end
  end
end

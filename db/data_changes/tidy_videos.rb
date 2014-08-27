['3DS Max 101 - ',
  '3DS Max ',
  'Adobe After Effects ',
  'Adobe InDesign 101 ',
  'Adobe Lightroom ',
  'Adobe Photoshop 101 ',
  'Adobe Premiere 101 ',
  'After Effects 101 ',
  'Auto CAD 101 ',
  'AutoCAD - ',
  'Captivate 201',
  'Captivate ',
  'CSS 101 - ',
  'Dreamweaver ',
  'Flash 101 ',
  'Flash 201 ',
  'Flash Actionscript 301 - ',
  'HTML - ',
  'Illustrator 101 - ',
  'Illustrator 101 ',
  'Illustrator 201 ',
  'Illustrator ',
  'InDesign 101 - ',
  'Indesign 101, ',
  'Indesign 101',
  'Indesign 201',
  'Indesign ',
  'iOS Developer 101 - ',
  'Javascript - ',
  'Photoshop 101 ',
  'Photoshop 201 ',
  'Photoshop ',
  'PS 101 '
].each do |title|
  vp_title = title.gsub(/ \- /, "").gsub(/ $/, "")
  vp_title = 'Photoshop' if vp_title == 'PS 101' || vp_title == "Photoshop 101" || vp_title == "Photoshop 201"
  vp_title = "iOS Developer" if vp_title == "iOS Developer 101"
  vp_title = "Indesign" if vp_title.downcase.match(/indesign/)
  vp_title = "Illustrator" if vp_title.downcase.match(/illustrator/)
  vp_title = "Dreamweaver 101" if vp_title.downcase.match(/dreamweaver/)
  vp_title = "Cascading Style Sheets" if vp_title == "CSS 101"
  vp_title = "Captivate 201" if vp_title == "Captivate 201"
  vp_title = "Captivate 101" if vp_title == "Captivate"
  vp_title = "AutoCAD" if vp_title == "Auto CAD 101"
  vp_title = "Premiere Pro" if vp_title == "Adobe Premiere 101"
  vp_title = "Photoshop" if vp_title == "Adobe Photoshop 101"
  vp_title = "Indesign" if vp_title == "Adobe InDesign 101"
  vp_title = "After Effects" if vp_title == "Adobe After Effects"
  vp_title = "3DS Max" if vp_title == "3DS Max 101"
  vp = VideoProduct.find_by_name(vp_title)
  if (vp)
    Video.where("title LIKE ?", title + "%").each do |t|
      puts "Adding #{t.title} to #{vp.name} (#{vp_title})" if t.title.downcase.match(/ps 101/)
      t.title = t.title[title.length..-1]
      t.save
      VideoProductMember.create({:video_product => vp, :video => t})
    end
  else
    puts "No video product found named #{vp_title}"
  end
  
  Video.connection.execute("UPDATE videos SET title = substr(title FROM #{title.length}) WHERE title LIKE '#{title} %'")
  
end
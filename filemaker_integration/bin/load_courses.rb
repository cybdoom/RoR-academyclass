require "fileutils"
require "date"
require 'mysql'

mysql = Mysql.init()
mysql.connect('localhost', 'academyclass', '9xN3,oad4', 'academyclass_courses')

web_mysql = Mysql.init()
web_mysql.connect('localhost', 'root', nil, 'academyclass_development')
@courses = {}
web_mysql.query("SELECT id, name FROM courses").each do |course|
  @courses[course[1].gsub(/:/, "")] = course[0]
end


def get_course_id(course_name)
  case course_name
  when "Digital Photography 101:Rookie" then return 156
    #when "Illustrator - Introduction" then return 
    #when "AutoCAD � Essentials" then return 
    #when "Flex - Developing Rich Client Applications Level 1" then return 35
    #when "Photoshop - Introduction" then return 
    #when "InDesign - Introduction" then return 
    #when "Illustrator - Advanced" then return 
    #when "Flash - Rich Content Creation" then return 
    #when "AutoCAD - Level 2 - Intermediate" then return 
    #when "Flex  - Data and Communications" then return 36
  when "Final Cut Pro - Introduction" then return 
  when "Quark Xpress - Introduction" then return 
  when "InDesign - Advanced" then return 
  when "Acrobat 201 Hotshot" then return 
  when "Dreamweaver - Web Development Introduction" then return 
  when "Room Hire" then return 
  when "Flash - Advanced Actionscript" then return 
  when "Premiere Pro - Introduction" then return 
  when "Flex - Building Dashboard Applications Level 2" then return 
  when "AfterEffects - Introduction" then return 
  when "3ds Max - Essentials Masterclass" then return 
  when "Flash - Actionscript" then return 
  when "Maya Jumpstart: Zero to Hero" then return 
  when "Photoshop - Extended" then return 
  when "\"Ajax - Fast Track to AJAX, Introduction\"" then return 
  when "Photoshop - Advanced" then return 
  when "3ds Max Advanced" then return 
  when "Jon Bessant - Acrobat" then return 
  when "Cascading Style Sheets" then return 
  when "Final Cut Pro Advanced" then return 
  when "Captivate - Introduction" then return 
  when "3ds Max Jumpstart Zero to Hero" then return 
  when "Acrobat - Introduction" then return 
  when "Final Cut Pro 6 - Masterclass" then return 
  when "Motion Introduction" then return 
  when "Fireworks - Web Graphic Creation" then return 
  when "Cinema 4D � Fundamental" then return 
  when "Revit Architecture - Essentials" then return 
  when "Soundbooth CS3 - Introduction" then return 
  when "Flash - Video Development" then return 
  when "Acrobat - Advanced" then return 
  when "Combustion Fundamentals" then return 
  when "Motion Introdction" then return 
  when "Coldfusion - Fast Track to Coldfusion" then return 
  when "Dreamweaver - Dynamic Application Development" then return 
  when "Flash Lite - Mobile Application Development" then return 
  when "Acrobat 3D" then return 
  when "Cinema 4D � Intermediate" then return 
  when "Flex 3 - Programming the Visual Experience" then return 
  when "Cascading Style SheetsCascading Style Sheets" then return 
  when "AutoCAD � 3d Modelling" then return 
  when "PHP/MySQL" then return 
  when "Indesign ACE" then return 
  when "Premiere Bespoke" then return 
  when "Photoshop ACE" then return 
  when "Flash - Bespoke" then return 
  when "3ds Max for Games" then return 
  when "Ajax Custom" then return 
  when "Custom Flash" then return 
  when "Web Forms and Video custom" then return 
  when "Acrobat 3d" then return 
  when "Acrobat 7 � 3D" then return 
  when "Acrobat 8 - Masterclass" then return 
  when "Illustrator CS3 - New Features" then return 
  when "Jon Bessant" then return 
  when "Flex 2 - MasterClass" then return 
  when "PHP and my SQL - Introduction" then return 
  when "Excel Training" then return 
  when "Customised Acrobat Training" then return 
  when "Quark Xpress - Level 1 Introduction" then return 
  when "Custom Creative Suite Video" then return 
  when "InCopy CS3" then return 
  when "Combustion 4 Fundamentals" then return 
  when "1/2/01" then return 
  when "Zoe Room Hire" then return 
  when "Flex 2 - Building Dashboard Applications Level 2" then return 
  when "Illustrator 1-2-1" then return 
  when "acrobat level 1" then return 
  when "acrobat level 2" then return 
  when "After Effects" then return 
  when "3D with the Compositing Process in Mind" then return 
  when "RoboHelp HTML-Based Help" then return 
  when "Bring Your Own Laptop" then return 
    
  when "Freehand Custom Course" then return 
  when "Digital Repro and Prepress" then return 
  when "Training Vouchers" then return 
  when "Custom Course" then return 
  when "DVD Studio Pro 4" then return 
  when "AutoCAD & AutoCAD LT � Essentials" then return 
  when "3ds Max - Essentials Master Class" then return 
  when "ajax - custom" then return 
  when "Flex 2 - Programming the Visual Experience" then return 
  when "Custom Quark" then return 
  when "room Hire" then return 
  when "Custom Vray" then return 
  when "XML - Introduction" then return 
  when "LiveCycle Designer 7.1 Forms Creation" then return 
  when "Custom 3DS Max" then return 
  when "Custom Indesign" then return 
  when "v-ray" then return 
  when "PMA Room Hire" then return 
  when "Aperture 101: An Introduction to Aperture" then return 
  when "Indesign CS3 - New Features Class" then return 
  when "custom creative suite" then return 
  when "custom video production training" then return 
  when "motion" then return 
  when "apple room hire and lunches" then return 
  when "Photoshop  - Introduction" then return 
  when "Captivate" then return 
  when "Flex 3 - MasterClass" then return 
  when "Room Hire PMA" then return 
  when "After Effects CS3 - Intermediate" then return 
    
  when "Cancelled" then return 
  when "Quark XPress - Advanced" then return 
  when "Bespoke Flash/Flex" then return 
  when "Avid Intermediate" then return 
  when "cancelled" then return 
  when "VectorWorks" then return 
  when "AfterEffects - Advanced" then return 
  when "Combustion  Fundamentals" then return 
  when "Soundbooth - Introduction" then return 
  when "SEO & Pay per Click Management" then return 
  when "Email Marketing" then return 
  when "Web Usability" then return 
  when "Quark Xpress - Advanced" then return 
  when "Quark to Indesign" then return 
  when "ACE Bespoke" then return 
  when "Avid Introduction" then return 
  when "css & accessibility" then return 
  when "Color 101: Introduction to color" then return 
  when "DVD Studio Pro" then return 
  when "Bring your Own Laptop" then return 
  when "Bespoke Dreamweaver + CSS" then return 
  when "Room Hire Cryptic" then return 
  when "Bespoke CSS" then return 
  when "Room Hire Logic" then return 
  when "AutoCAD Architecture: Introduction" then return 
  when "xxx" then return 
  when "HTML: Introduction" then return 
  when "Javascript Level 1 - Introduction" then return 
  when "Google Sketch Up" then return 
  when "InDesign ACE" then return 
  when "Illustrator ACE" then return 
  when "Flex Level: Extending and Styling Components" then return 
  when "Flex Level: Introducing Cairngorm" then return 
  when "AIR: Building Desktop Applications" then return 
  when "Ruby on Rails" then return 
  when "Inventor: Level 1 Essentials" then return 
  when "AutoCAd Architecture: Introduction" then return 
  when "Logic 101: Level 1" then return 
  when "Creative Suite 4 JumpStart - New Features" then return 
  when "Expenses" then return 
  when "Mental Ray" then return 
  when "Quark to InDesign" then return 
  when "Bring your own laptop" then return 
  when "Video Encoding For The Web & Multimedia" then return 
  when "Illustrator 1 to 1" then return 
  when "Search Engine Optimisation" then return 
  when "Indesign - Advanced" then return 
  when "Search Marketing (PPC)" then return 
  when "InDesign 201 Hotshot" then return 
  when "Bespoke After Effects" then return 
  when "Training Vouchers - Revit" then return 
  when "AfterEffects - Intermediate" then return 
  when "Logic 101: Introduction" then return 
  when "Bespoke Maya" then return 
  when "Photoshop CS4 ACA" then return 
  when "Livecycle ES" then return 
  when ""AIR, Adobe Integrated Runtime:"" then return 
  when "Bespoke Cinema" then return 
  when "Adobe AIR: Building Desktop Applications with Flex" then return 
  when "XSI: Introduction" then return 
  when "Bespoke Course" then return 
  when "PowerUP with Final Cut Studio" then return 
  when "Photoshop ACA" then return 
  when "Larry Jordan MasterClass" then return 
  when "Framemaker Introduction" then return 
  when "Dreamweaver CS4 HTML Newsletters" then return 
  when "Flex Consultancy" then return 
  when "Logic 101 - Exam" then return 
  when "Bespoke - on-site" then return 
  when "AutoCAD 201 Hotshot" then return 
  when "After Effects 201 Hotshot" then return 
  when "Photoshop 201 Hotshot" then return 
  when "Flash ACA" then return 
  when "Cascading Style Sheets 101 Rookie" then return 
  when "Flex Data and Communications" then return 
  when "QuarkXPress 101 Rookie" then return 
  when "Ajax 101 Rookie" then return 
  when "3ds Max 201 Hotshot" then return 
  when "Dreamweaver ACA" then return 
  when "Flash 301 - Actionscript Rookie" then return 
  when "AutoCAD ACA Prep / Exam" then return 
  when "Flash 401 ActionScript HotShot" then return 
  when "Flex 101 Developing RIAs" then return 
  when "AutoCAD 301  3d Modelling" then return 
  when "Cinema 4D 201 Hotshot" then return 
  when "LiveCycle Designer - Forms Creation" then return 
  when "PHP & My SQL 101 Rookie" then return 
  when "Bespoke - At Academy Class" then return 
  when "Illustrator 201 Hotshot" then return 
  when "Mac OS X Support Essentials" then return 
  when "Mac OS X Server - Essentials" then return 
  when "Flash 301 ActionScript Rookie" then return 
  when "Flash 301 - Actionscript" then return 
  when "Final Cut Pro 300 Hotshot" then return 
  when "Mac OS X Server Essentials" then return 
  when "Apple Exam" then return 
  when "Photoshop 101 Rookie (EVE)" then return 
  when "Framemaker 101 Rookie" then return 
  when "Dreamweaver ACA (Eve)" then return 
  when "Flash 101 Rookie (EVE)" then return 
  when "Flex: Jumpstart - zero to Hero" then return 
  when "iPhone Developer 101 Rookie" then return 
  when "Developing a PR Strategy 101" then return 
  when "Fast Track Digital Marketing" then return 
  when "Digital Repro and Prepress 101 Rookie" then return 
  when "Javascript 101 Rookie" then return 
  when "Dreamweaver Day 4 ACA" then return 
  when "Dreamweaver 201 Hotshot" then return 
  when "Adobe AIR 101 Rookie" then return 
  when "Ruby on Rails 101 Rookie" then return 
  when "Maya Jumpstart Zero to Hero" then return 
  when "Premiere Pro 201 Hotshot" then return 
  when "Autodesk Exam" then return 
  when "Photoshop 101 ACA Weekends" then return 
  when "Accessible Websites Introduction" then return 
  when "XML Introduction" then return 
  when "InDesign 101 Weekends" then return 
  when "Illustrator 101 Weekends" then return 
  when "Dreamweaver 101 Rookie (EVE)" then return 
  when "Social Media 101: Rookie" then return 
  when "Powerpoint 2007 MCAS" then return 
  when "Flash 101 ACA Weekends" then return 
  when "Dreamweaver 101 ACA Weekends" then return 
  when "VMWare Training (QA)" then return 
  when "Captivate 201 Hotshot" then return 
  when "InDesign 101 Rookie (EVE)" then return 
  when "The Designers Creative License" then return 
  when "Apple Core Skills" then return 
  when "Coldfusion 101 Rookie" then return 
  when "Silverlight 101: Rookie" then return 
  when "Bespoke - Client Site" then return 
  when "Search Engine Optimisation 101 Rookie" then return 
  when "10 Training Voucher days" then return 
  when "Flex: Charting & Dashboard Apps" then return 
  when "Graphic Design Concepts" then return 
  when "**HOLIDAY**" then return 
  when "QuarkXPress 201 Hotshot" then return 
  when "Adobe Print Production Workflow" then return 
  when "Designers Fiesta" then return 
  when "WACOM DAY" then return 
  when "Design Techniques & Graphic Design Concepts 101" then return 
  when "Photoshp ACE" then return 
  when "Podcasts / Vodcasts 101: Rookie" then return 
  when "Email Marketing 101 Rookie" then return 
  when "Indesign 301 Super HotShot" then return 
  when "Adobe Eseminars" then return 
  when "Course Preps" then return 
  when "sick" then return 
  when "Ilife rookie 101" then return 
  when "Iwork 101 Rookie" then return 
  when "AutoCAD ACE" then return 
  when "Softimage 101: Jumpstart" then return 
  when "Dreamweaver ACA Jumpstart Weekends" then return 
  when "Digital Art 201 Hotshot" then return 
  when "Illustrator 301 Super HotShot" then return 
  when "Dreamweaver for Newsletters" then return 
  when "Photoshop for Photographers Rookie" then return 
  when "Dreamweaver ACA + Prep" then return 
  when "OFFICE CLOSED" then return 
  when "AC XMAS PARTYYYYYY!!!" then return 
  when "Final Cut Pro 101 Rookie Weekend" then return 
  when "Autocad Rookie Weekend" then return 
  when "InDesign 201 Weekends" then return 
  when "Photoshop 201 Weekend" then return 
  when "Illustrator 201 Weekend" then return 
  when "Flash 201 Weekend" then return 
  when "Soundtrack Pro" then return 
  else @courses[course_name]
  end
end

file = File.open(File.join(FileUtils.pwd, "filemaker_integration", "data", "courses.txt"), "r")
locations = ["London", "Glasgow", "Cardiff", "Manchester", "Edinburgh", "Newcastle", "Birmingham", "Leeds"]
skipped = []
while line = file.readline
  data = line.split(/\t/)
  location = data[4] ? data[4].strip : nil
  location = "Cardiff" if location == "Cardff"
  location = "Manchester" if location == "manchester"
  location = "Manchester" if location == "Manchester (CP)"
  location = "London" if location == "London Bridge"
  location = "London" if location == "Regents Park"
  
  course_name = data[0]
  id = data[1].to_i
  if id > 0 && course_name && locations.include?(location)
    course_name.strip!
    start_date = Date.strptime(data[2], "%d/%m/%y")
    course_id = get_course_id(course_name)
    if !course_id
      unless skipped.include?(course_name)
        skipped << course_name
        puts "when \"#{course_name}\" then return "
      end
    end
    #sql = "INSERT INTO course_mappings (name, id, start_date, location, course_id) VALUES ('#{course_name}', #{id}, '#{start_date.strftime("%Y-%m-%d")}', '#{location}', #{course_id})"
    #puts sql
    #mysql.query(sql)
  end
end

mysql.close()
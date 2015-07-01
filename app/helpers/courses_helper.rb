# encoding: utf-8
module CoursesHelper

  def display_cost(course)
    return "&pound;#{"%01d" % course.cost} <small>ex VAT</small>" if course.cost
    return "Call for details";
  end
  
  def display_cost_plaintext(course)
    return "£#{"%01d" % course.cost} ex VAT" if course.cost && course.cost > 0
    return "Call for details";
  end

  def qa_category_options
    [
      "Adobe (BA)",
      "Crystal Reports (BA)",
      "Institute of IT Training (BA)",
      "Microsoft (BA)",
      "Finance and Accountancy (BFS)",
      "Human Resources (BFS)",
      "Learning and Development (BFS)",
      "Legal (BFS)",
      "Marketing (BFS)",
      "Procurement (BFS)",
      "Sales (BFS)",
      "Generic Business Systems Development (BSD)",
      "ISEB Business Systems (BSD)",
      "ISEB Enterprise Architecture (BSD)",
      "TOGAF (BSD)",
      "CompTIA (IT)",
      "Acronis (IT)",
      "Applications Programming (IT)",
      "AppSense (IT)",
      "C, C++, COBOL (IT)",
      "Cisco (IT)",
      "Citrix (IT)",
      "Cloud Computing (IT)",
      "Data Communications (IT)",
      "Database and Business Intelligence (IT)",
      "Dreamweaver (IT)",
      "IBM (IT)",
      "Internet Technologies (IT)",
      "Information Security (IT)",
      "Java (IT)",
      "Linux (IT)",
      "Microsoft (IT)",
      "Novell (IT)",
      "Oracle (IT)",
      "Perl Python (IT)",
      "Red Hat (IT)",
      "SAP (IT)",
      "Sun (IT)",
      "Symantec (IT)",
      "System Architecture and Design (IT)",
      "Multi-vendor UNIX (IT)",
      "VMWARE (IT)",
      "Other (IT)",
      "Business Relationships (PD)",
      "Communication Skills (PD)",
      "Customer Service (PD)",
      "Management and Leadership (PD)",
      "Personal Effectiveness (PD)",
      "Agile (PPM)",
      "Association for Project Management (APM) (PPM)",
      "Generic Project & Programme Management (PPM)",
      "Green IT (PPM)",
      "Management of Portfolios (PPM)",
      "Management Of Risk (PPM)",
      "Managing Successful Programmes (MSP) (PPM)",
      "P30(R) Portfolio Programme & Project Off (PPM)",
      "Principles of Change Management (PPM)",
      "Project Management Institute (PMI) (PPM)",
      "PRINCE2 (R) (PPM)",
      "Scrum (PPM)",
      "Lean Six Sigma (PPM)",
      "Environment and Business Sustainability (PQ)",
      "Finance and Accountancy (PQ)",
      "Human Resources (PQ)",
      "Management (PQ)",
      "Electrical Safety (PQ)",
      "Fire Safety (PQ)",
      "First Aid (PQ)",
      "ISO (SM)",
      "ITIL (SM)",
      "Service Desk Institute (SDI) (SM)"
    ]
  end
end
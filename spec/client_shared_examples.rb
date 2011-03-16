shared_examples_for "a full profile fetch" do
  it "should retrieve their name" do
    profile.first_name.should == 'Wynn'
    profile.last_name.should  == 'Netherland'
  end

  it "should retrieve location information" do
    profile.location.name.should    == 'Dallas/Fort Worth Area'
    profile.location.country.should == 'us'
  end

  it "should retrieve positions from a profile" do
    profile.positions.size.should == 4
    profile.positions.first.company.name.should == 'Orrka'
    profile.positions.first.is_current.should   == 'true'

    hp = profile.positions[2]
    hp.title.should       == 'Solution Architect'
    hp.id.should          == '4891362'
    hp.start_month.should == 10
    hp.start_year.should  == 2004
    hp.end_month.should   == 6
    hp.end_year.should    == 2007
    hp.is_current.should  == 'false'
  end

  it "should retrieve education information from a profile" do
    education = profile.educations.first
    education.start_month.should == 8
    education.start_year.should  == 1994
    education.end_month.should   == 5
    education.end_year.should    == 1998
  end

  it "should retrieve information about a profiles connections" do
    profile.connections.size.should == 146
    profile.connections.first.first_name.should == "Ali"
  end

  it "should retrieve a profiles member_url_resources" do
    profile.member_url_resources.size.should == 2
    profile.member_url_resources.first.url.should  == 'http://orrka.com'
    profile.member_url_resources.first.name.should == 'My Company'
  end

  it "should retrieve a profiles connections api_standard_profile_request" do
    p1 = profile.connections.first
    p1.api_standard_profile_request.url.should == 'http://api.linkedin.com/v1/people/3YNlBdusZ5:full'
    p1.api_standard_profile_request.headers[:name].should  == 'x-li-auth-token'
    p1.api_standard_profile_request.headers[:value].should == 'name:lui9'
  end

  it "should retrieve a site_standard_profile_request" do
    profile.site_standard_profile_request.should == "http://www.linkedin.com/profile?viewProfile=&key=3559698&authToken=yib-&authType=name"
  end

  it "should retrieve skills from a profile" do
    skill = profile.skills.last
    skill.name.should == "Union negotiations"
    skill.id.to_i.should == 38
  end

  it "should retrieve phone_number from a profile" do
    pn = profile.phone_numbers.last

    pn.phone_type.should == "mobile"
    pn.phone_number.should == "+444444444444"
  end

  it "should retrieve publications from a profile" do
    publication = profile.publications.last

    publication.id.to_i.should == 31
    publication.title.should == "How to host an awesome podcast"
    publication.date.should == Date.civil(y=2006,m=8,d=1)
  end

  it "should retrieve patents from a profile" do
    patent = profile.patents.last

    patent.id.to_i.should == 51
    patent.title.should == "Time machine"
    patent.date.should == Date.civil(y=2008,m=7,d=23)
  end

  it "should retrieve language information from a profile" do
    language = profile.languages.last
    language.name.should == "Klingon"
    language.id.to_i.should == 72
  end
end

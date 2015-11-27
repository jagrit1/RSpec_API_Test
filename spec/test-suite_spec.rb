require 'spec_helper'

describe "Test Suite sends a post request" do
  it "should create a new post in collection" do
     #execute
      r= HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query:{title: "A new Item", due: "2014-10-01"}
     #verify
      expect(r["title"]).to eq("A new Item")
      expect(r['due']).to eq("2014-10-01")
      expect(r.message).to eq("Created")
      expect(r.code).to eq(201)

    #teardown
    HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{r['id']}"
  end
  it "sould not make a post without proper arguments" do
      r= HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query:{title: "A new Item"} 
      #verify
      expect(r.code).to eq(422)
      expect(r.message).to eq("Unprocessable Entity")
  end
  it "should not make a post without any arguments" do
      r= HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query:{} 
     #verify
      expect(r.code).to eq(422)
      expect(r.message).to eq("Unprocessable Entity")
  end

  it "should not allow a new post in collection with the existing id" do
     #execute
      r= HTTParty.post "http://lacedeamon.spartaglobal.com/todos/2993", query:{title: "A new Item", due: "2014-10-01"}
     #verify
      expect(r["title"]).to eq nil
      expect(r['due']).to eq nil
      expect(r.code).to eq(405)
  end
end

describe "Test Suite sends a get request" do
  it "should get a  post from collection given a specific id" do
     #execute
      q= HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query:{title: "An absolutely new Item", due: "2014-10-01"}
      r= HTTParty.get "http://lacedeamon.spartaglobal.com/todos/#{q['id']}"
     #verify
      expect(r["title"]).to eq("An absolutely new Item")
      expect(r['due']).to eq("2014-10-01")
      expect(r.message).to eq("OK")
      expect(r.code).to eq(200)
  end
  
  it "should return an empty hash from an empty ID" do
      r= HTTParty.get "http://lacedeamon.spartaglobal.com/todos/01"
      expect(r.code).to eq(404)
  end 
  
  it "should return all IDs if collection is requested" do
    #execute
      post1= HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query:{title: "An absolutely new Item1", due: "2014-10-01"}
      post2= HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query:{title: "An absolutely new Item2", due: "2015-10-01"}
      r= HTTParty.get "http://lacedeamon.spartaglobal.com/todos"
    #verify
      expect(r.message).to eq("OK")
      expect(r.code).to eq(200)
      expect(r.content_type).to eq("application/json")

    #teardown
      HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{post1['id']}"
      HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{post2['id']}"
  end
end

describe "Test Suite sends a put request" do
    #execute

    it "should update a single todo from an ID" do
    q= HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query:{title: "A new Item", due: "2014-10-01"}
    r= HTTParty.put "http://lacedeamon.spartaglobal.com/todos/#{q['id']}", query:{title: "An updated absolutely new Item1", due: "2013-10-01"}
    #verify
    expect(r["title"]).to eq("An updated absolutely new Item1")
    expect(r['due']).to eq("2013-10-01")
    expect(r.message).to eq("OK")
    expect(r.code).to eq(200)


  #teardown
    HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{q['id']}"
      
    end

    it "sould not make a update to the whole collection" do
      r= HTTParty.put "http://lacedeamon.spartaglobal.com/todos"
      #verify
      expect(r.code).to eq(405)
      expect(r.message).to eq("Method Not Allowed")
  end
end

































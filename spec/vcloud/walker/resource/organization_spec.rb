require 'spec_helper'

describe Vcloud::Walker::Resource::Organization do

  it "should retrieve networks" do
    fog_networks = double(:fog_networks)
    expect(Vcloud::Walker::FogInterface).to receive(:get_networks).and_return(fog_networks)
    expect(Vcloud::Walker::Resource::Networks).to receive(:new).with(fog_networks).
      and_return(double(:walker_networks, :to_summary => [:network => "Network 1"]))
    expect(Vcloud::Walker::Resource::Organization.networks).to eq([:network => "Network 1"])
  end

  it "should retrieve catalogs" do
    fog_catalogs = double(:fog_catalogs)
    expect(Vcloud::Walker::FogInterface).to receive(:get_catalogs).and_return(fog_catalogs)
    expect(Vcloud::Walker::Resource::Catalogs).to receive(:new).with(fog_catalogs).
      and_return(double(:walker_catalogs, :to_summary => [:catalog => "Catalog 1"]))
    expect(Vcloud::Walker::Resource::Organization.catalogs).to eq([:catalog => "Catalog 1"])
  end

  it "should retrieve vdcs" do
    fog_vdcs = double(:fog_vdcs)
    expect(Vcloud::Walker::FogInterface).to receive(:get_vdcs).and_return(fog_vdcs)
    expect(Vcloud::Walker::Resource::Vdcs).to receive(:new).with(fog_vdcs).
      and_return(double(:walker_vdcs, :to_summary => [:vdc => "VDC 1"]))
    expect(Vcloud::Walker::Resource::Organization.vdcs).to eq([:vdc => "VDC 1"])
  end

  it "should retrieve edgegateways" do
    fog_edgegateways = [{
      :id => 'urn:vcloud:gateway:1',
      :href => 'host/1',
      :name => 'Gateway 1',
      :Configuration => { :EdgeGatewayServiceConfiguration => {}}
    }]
    expect(Vcloud::Walker::FogInterface).to receive(:get_edge_gateways).
      and_return(fog_edgegateways)

    expect(Vcloud::Walker::Resource::Organization.edgegateways).to eq([{
      :id => '1',
      :name => 'Gateway 1',
      :href => 'host/1',
      :Configuration => { :EdgeGatewayServiceConfiguration => {} },
    }])
  end

  it "should retrive entire organization" do
    expect(Vcloud::Walker::Resource::Organization).to receive(:edgegateways).
      and_return([:edgegateway => 'Gateway 1'])
    expect(Vcloud::Walker::Resource::Organization).to receive(:vdcs).
      and_return([:vdc => "VDC 1"])
    expect(Vcloud::Walker::Resource::Organization).to receive(:catalogs).
      and_return([:catalog => "Catalog 1"])
    expect(Vcloud::Walker::Resource::Organization).to receive(:networks).
      and_return([:network => "Network 1"])

    expect(Vcloud::Walker::Resource::Organization.organization).to eq({
        :vdcs => [{ :vdc => "VDC 1" }],
        :networks => [{ :network => "Network 1" }],
        :catalogs => [{ :catalog => "Catalog 1" }],
        :edgegateways => [{ :edgegateway => "Gateway 1" }]
    })
  end

end


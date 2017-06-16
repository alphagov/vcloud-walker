module Fog
  module ServiceLayerStub
    def self.vapp_body
      {:name => "vapp-atomic-centre",
       :id => "urn:vcloud:vm:aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee",
       :href => 'https://myvdc.carrenza.net/api/vApp/vapp-aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee',
       :status => "on",
       :description => "hosts the atomic centre app",
       :deployed => true,
       :NetworkConfigSection => {:NetworkConfig => [{:networkName => "Default", :IsDeployed => true, :Description => "default network",
                                                     :Configuration => {:IpScopes => 'abc'}, :ParentNetwork => nil}]},
       :"ovf:NetworkSection" => {:'ovf:Network' => 'network'},
       :Children =>
           {
               :Vm =>
                   {
                       :needsCustomization => "true",
                       :deployed => "true",
                       :status => "4", :name => "ubuntu-precise-201309091031",
                       :id => "urn:vcloud:vm:d19d84a5-c950-4497-a638-23eccc4226a5",
                       :type => "application/vnd.vmware.vcloud.vm+xml",
                       :href => "https://api.vcd.portal.examplecloud.com/api/vApp/vm-d19d84a5-c950-4497-a638-23eccc4226a5",
                       :Description => "ubuntu-precise | Version: 1.0 | Built using BoxGrinder",
                       :"ovf:OperatingSystemSection" =>
                           {
                               :"ovf:Description" => "Ubuntu Linux (64-bit)"
                           },
                       :NetworkConnectionSection =>
                           {
                               :ovf_required => "false",
                               :"ovf:Info" => "Specifies the available VM network connections",
                               :PrimaryNetworkConnectionIndex => "0",
                               :NetworkConnection =>
                                   {
                                       :network => "Default",
                                       :needsCustomization => "true",
                                       :NetworkConnectionIndex => "0",
                                       :IpAddress => "192.168.2.2",
                                       :IsConnected => "true",
                                       :MACAddress => "00:50:56:01:0b:1a",
                                       :IpAddressAllocationMode => "MANUAL"
                                   },
                           },
                       :'ovf:VirtualHardwareSection' =>
                           {
                               :'ovf:Item' => [],
                               :"ovf:System" =>
                                   {:"vssd:ElementName" => "Virtual Hardware Family", :"vssd:VirtualSystemType" => "vmx-08"}
                           },
                       :RuntimeInfoSection =>
                           {
                               :VMWareTools => {:version => "2147483647"}
                           },
                       :StorageProfile =>
                           {
                               :type => "application/vnd.vmware.vcloud.vdcStorageProfile+xml",
                               :name => "TEST-STORAGE-PROFILE",
                               :href => "https://api.vcd.portal.examplecloud.com/api/vdcStorageProfile/00000000-aaaa-bbbb-aaaa-000000000000"
                           }
                   }
           }
      }
    end

    def self.mock_vapp
      RSpec::Mocks::Double.new(:fog_vapp, :body => vapp_body)
    end

    def self.vcloud_director_five_one_ids
      {
        :disk_capacity_label => :ns12_capacity
      }
    end

    def self.vcloud_director_5_5_with_v5_1_api_ids
      {
        :disk_capacity_label => :vcloud_capacity
      }
    end



    def self.hardware_resources version_specific_ids
      [
          {
              :'rasd:ResourceType' =>:: Vcloud::Walker::Resource::Vm::HARDWARE_RESOURCE_TYPES[:hard_disk],
              :"rasd:AddressOnParent" => "0",
              :"rasd:Description" => "Hard disk",
              :"rasd:ElementName" => "Hard disk 1",
              :"rasd:HostResource" => {version_specific_ids[:disk_capacity_label] => "11265",
                                                            :ns12_busSubType => "lsilogic",
                                                            :ns12_busType => "6"},
          },

          {
              :'rasd:ResourceType' => ::Vcloud::Walker::Resource::Vm::HARDWARE_RESOURCE_TYPES[:hard_disk],
              :"rasd:AddressOnParent" => "1",
              :"rasd:Description" => "Hard disk",
              :"rasd:ElementName" => "Hard disk 2",
              :"rasd:HostResource" => {version_specific_ids[:disk_capacity_label] => "307200",
                                                            :ns12_busSubType => "lsilogic",
                                                            :ns12_busType => "6"}
          },
          {
              :'rasd:ResourceType' => ::Vcloud::Walker::Resource::Vm::HARDWARE_RESOURCE_TYPES[:cpu],
              :"rasd:Description" => "Number of Virtual CPUs",
              :"rasd:ElementName" => "2 virtual CPU(s)"
          },
          {
              :'rasd:ResourceType' => ::Vcloud::Walker::Resource::Vm::HARDWARE_RESOURCE_TYPES[:memory],
              :"rasd:Description" => "Memory Size",
              :"rasd:ElementName" => "4096 MB of memory"
          },
          {
              :'rasd:ResourceType' => ::Vcloud::Walker::Resource::Vm::HARDWARE_RESOURCE_TYPES[:network_adapter],
              :'rasd:Address'     => '00:50:56:00:00:01',
              :'rasd:AddressOnParent' => '0',
              :'rasd:AutomaticAllocation' => true,
              :'rasd:Description' => 'E1000 ethernet adapter on "Default"',
              :'rasd:ElementName' => 'Network adapter 0',
              :'rasd:InstanceID'  => '0',
              :'rasd:ResourceSubType' => 'E1000',
          },
      ]
    end
  end
end

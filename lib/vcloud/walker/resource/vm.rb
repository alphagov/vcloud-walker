module Vcloud
  module Walker
    module Resource
      class Vms < Collection
        def initialize fog_vms
          fog_vms = [fog_vms] unless fog_vms.is_a? Array
          fog_vms.each do |vm|
            self << Resource::Vm.new(vm)
          end
        end
      end


      class Vm < Entity

        attr_reader :id, :status, :cpu, :memory, :operating_system, :disks,
                    :primary_network_connection_index, :vmware_tools,
                    :virtual_system_type, :network_connections, :storage_profile,
                    :network_cards, :metadata

        HARDWARE_RESOURCE_TYPES = {
            :cpu => '3',
            :memory => '4',
            :hard_disk => '17',
            :network_adapter => '10'
        }

        def initialize fog_vm
          @id = extract_id(fog_vm[:href])
          @status = fog_vm[:status]
          @operating_system = fog_vm[:'ovf:OperatingSystemSection'][:'ovf:Description']
          @network_connections = fog_vm[:NetworkConnectionSection][:NetworkConnection] if fog_vm[:NetworkConnectionSection]
          @primary_network_connection_index = fog_vm[:NetworkConnectionSection][:PrimaryNetworkConnectionIndex]
          extract_compute_capacity fog_vm[:'ovf:VirtualHardwareSection'][:'ovf:Item']
          @vmware_tools = fog_vm[:RuntimeInfoSection][:VMWareTools]
          @virtual_system_type = extract_virtual_system_type(fog_vm[:'ovf:VirtualHardwareSection'])
          @storage_profile = {
            :id   => fog_vm[:StorageProfile][:href].split('/').last,
            :name => fog_vm[:StorageProfile][:name],
          }
          @metadata = Vcloud::Core::Vm.get_metadata(id)
        end


        private
        def extract_compute_capacity ovf_resources
          %w(cpu memory disks network_cards).each { |resource| send("extract_#{resource}", ovf_resources) } unless ovf_resources.empty?
        end

        def extract_cpu(resources)
          @cpu = resources.detect { |element| element[:'rasd:ResourceType']== HARDWARE_RESOURCE_TYPES[:cpu] }[:'rasd:ElementName']
        end

        def extract_memory(resources)
          @memory = resources.detect { |element| element[:'rasd:ResourceType']== HARDWARE_RESOURCE_TYPES[:memory] }[:'rasd:ElementName']
        end

        def extract_disks(resources)
          disk_resources = resources.select { |element| element[:'rasd:ResourceType']== HARDWARE_RESOURCE_TYPES[:hard_disk] }
          @disks = disk_resources.collect do |d|
            {:name => d[:'rasd:ElementName'], :size => extract_disk_capacity(d)}
          end
        end

        def extract_disk_capacity(d)
          (d[:"rasd:HostResource"][:ns12_capacity] || d[:"rasd:HostResource"][:vcloud_capacity]).to_i
        end

        def extract_network_cards(resources)
          resources = resources.select {
            |element| element[:'rasd:ResourceType'] == HARDWARE_RESOURCE_TYPES[:network_adapter]
          }
          @network_cards = resources.collect do |r|
            {:name => r[:'rasd:ElementName'],
             :type => r[:'rasd:ResourceSubType'],
             :mac_address => r[:'rasd:Address'],
            }
          end
        end

        def extract_virtual_system_type virtual_hardware_section
          virtual_system = virtual_hardware_section[:"ovf:System"]
          virtual_system[:"vssd:VirtualSystemType"] if virtual_system
        end

      end
    end
  end
end

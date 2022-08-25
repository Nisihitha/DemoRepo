INSERT INTO neotenant.providers(id,name)
					VALUES('4ef35d32-d2da-65af-9cc0-c1e12e61ae53',
							'NEO Platform') ON CONFLICT DO NOTHING;INSERT INTO neotenant.apps(id,app_id,app_name,app_subdomain,
							app_description,app_type,latest_version_no,provider_id)
					VALUES('5bc3b73c-ec3a-4fbf-bec1-814127988b08','demo2',
									'demo2','demo2',
							null,
							'web',
							'1.0',
							'4ef35d32-d2da-65af-9cc0-c1e12e61ae53')ON CONFLICT (id) DO UPDATE SET app_name = 'demo2',latest_version_no = '1.0',app_description = null;INSERT INTO neotenant.app_configuration(id,app_id,config_name,configuration)
					VALUES('30c9220b-2f9b-4663-83d6-15ab0345b631','5bc3b73c-ec3a-4fbf-bec1-814127988b08',
									'test',
					'{}')
					ON CONFLICT (id) DO UPDATE SET config_name = 'test',configuration = '{}';INSERT INTO neotenant.app_roles(id,app_id,role_name,role_description) 
					VALUES('06eded04-3ea5-4853-9e6b-63d12a5356c8','5bc3b73c-ec3a-4fbf-bec1-814127988b08','admin',
					'admin')
					ON CONFLICT (id) DO UPDATE SET role_name = 'admin',
					role_description = 'admin';DELETE from neotenant.app_roles where app_id='5bc3b73c-ec3a-4fbf-bec1-814127988b08' 
												and NOT(id = ANY (string_to_array('06eded04-3ea5-4853-9e6b-63d12a5356c8',',')::UUID[] ));DELETE from neotenant.profile where app_id='5bc3b73c-ec3a-4fbf-bec1-814127988b08' ;DELETE from neotenant.role_feature_operations where 
					 id in (select rfo.id from neotenant.role_feature_operations rfo 
					inner join neotenant.app_roles ar on ar.id  = rfo.app_role_id and app_id='5bc3b73c-ec3a-4fbf-bec1-814127988b08'
					where NOT(rfo.id = ANY (string_to_array('',',')::UUID[])));
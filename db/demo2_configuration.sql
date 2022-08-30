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
					VALUES('3a88f8a6-9346-4a03-ae6f-0219a25193c4','5bc3b73c-ec3a-4fbf-bec1-814127988b08',
									'dev',
					'{"application_id":"demo2","graphql_url":"https://graphql.dev-neo.bcone.com/"}')
					ON CONFLICT (id) DO UPDATE SET config_name = 'dev',configuration = '{"application_id":"demo2","graphql_url":"https://graphql.dev-neo.bcone.com/"}';INSERT INTO neotenant.app_roles(id,app_id,role_name,role_description) 
					VALUES('06eded04-3ea5-4853-9e6b-63d12a5356c8','5bc3b73c-ec3a-4fbf-bec1-814127988b08','admin',
					'admin')
					ON CONFLICT (id) DO UPDATE SET role_name = 'admin',
					role_description = 'admin';DELETE from neotenant.app_roles where app_id='5bc3b73c-ec3a-4fbf-bec1-814127988b08' 
												and NOT(id = ANY (string_to_array('06eded04-3ea5-4853-9e6b-63d12a5356c8',',')::UUID[] ));INSERT INTO neotenant.profile(id,app_id,attribute_name,attribute_desc,profile_type,order_no,parent_id) 
					VALUES('f5408e2b-a494-4bef-89a9-2d80e1bff4c6','5bc3b73c-ec3a-4fbf-bec1-814127988b08','india',
					null,
					'1',
					'1',
					null)
					ON CONFLICT (id) DO UPDATE SET attribute_name = 'india',
					order_no = '1',
					attribute_desc = null;INSERT INTO neotenant.profile(id,app_id,attribute_name,attribute_desc,profile_type,order_no,parent_id) 
					VALUES('8fe9d77a-c359-4f49-8de7-b37cc8945ef8','5bc3b73c-ec3a-4fbf-bec1-814127988b08','karnataka',
					null,
					'3',
					'2',
					null)
					ON CONFLICT (id) DO UPDATE SET attribute_name = 'karnataka',
					order_no = '2',
					attribute_desc = null;INSERT INTO neotenant.profile(id,app_id,attribute_name,attribute_desc,profile_type,order_no,parent_id) 
					VALUES('1df425ec-7c04-402f-8f5d-e128e32b597d','5bc3b73c-ec3a-4fbf-bec1-814127988b08','AP',
					null,
					'3',
					'3',
					'8fe9d77a-c359-4f49-8de7-b37cc8945ef8')
					ON CONFLICT (id) DO UPDATE SET attribute_name = 'AP',
					order_no = '3',
					attribute_desc = null;DELETE from neotenant.profile where 
						app_id='5bc3b73c-ec3a-4fbf-bec1-814127988b08' and NOT(id = ANY (string_to_array ('1df425ec-7c04-402f-8f5d-e128e32b597d,8fe9d77a-c359-4f49-8de7-b37cc8945ef8,f5408e2b-a494-4bef-89a9-2d80e1bff4c6',',')::UUID[]));DELETE from neotenant.role_feature_operations where 
					 id in (select rfo.id from neotenant.role_feature_operations rfo 
					inner join neotenant.app_roles ar on ar.id  = rfo.app_role_id and app_id='5bc3b73c-ec3a-4fbf-bec1-814127988b08'
					where NOT(rfo.id = ANY (string_to_array('',',')::UUID[])));
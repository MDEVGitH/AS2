workspace "Taller" "Ejemplo de clase" {

    model {
        properties {
            "structurizr.groupSeparator" "/"
        }
        usuarios = group usuarios {
            usuario = person "Usuario general"
            admin = person "Administrador" "" "Posterior"
        }
        
        browser = softwareSystem "Web Browser" "" "Existing System, Browser"{
            usuario -> this "Usa"
            admin -> this "Usa"
        }
        
        robot = softwareSystem "Robot" "" "Existing System, Robot"
            
        sistema = softwareSystem "Taller Ejemplo" "Sistema de ejemplo" {
            !docs docs
            !adrs adrs

            vistas = group vistas {
                desk = container "Desktop" "" "" "Desktop"{
                    admin -> this "Usa"
                }
            
                tablet = container "Tablet" "" "" "Tablet"{
                    usuario -> this "Usa"
                }
                
                mobile = container "Mobile" "" "" "Mobile"{
                    usuario -> this "Usa"
                }
            
                webapp = container "Aplicación Web" "" "" "Browser" {
                    integrador = component integra "Integrador de contenido" "php"
                    notificaciones = component notifica "Manejador de notificaciones" "push"
                    mapas = component map "Visualizador de mapas" "LeafLet"
                    charts = component chart "Visualizador de gráficas" "Google Charts"
                    
                    browser -> integrador "Usa" "HTTP"
                    browser -> notificaciones "Usa" "HTTP"
                    integrador -> mapas "integra" "dHTML"
                    integrador -> charts "integra" "dHTML"
                }
            
            }
        
            servicios = container "Servicios"{
                ventasServ = component ventas "Servicio de ventas" "Java" "Posterior"
                usuariosServ = component usuarios "Servicio de usuarios" "Java"
                recomendadorServ = component recomendador "Servicio de recomendador" "Java"
                reportesServ = component reportes "Servicio de reportes" "Java"
                
                webapp -> this "Consume" "restFul"
                tablet -> this "Usa" "restFul"
                mobile -> this "Usa" "restFul"
                desk -> this "Usa" "restFul"
                robot -> this "Usa" "restFul"
            }
            database = container "DB" "Base de datos de ejemplo" "Schema Relacional" "db" {
				servicios -> this "Persiste en" "JNDI"
			}
        }
        
        ext = softwareSystem "ext" "Sistema externo" "Existing System"{
            sistema -> this "Consulta" "RestFul"
        }
        
        deploymentEnvironment "Monolito" {
            deploymentNode "Servidor Local" "localhost" "Windows, Linux o Mac" {
                deploymentNode "Tomcat" "Contenedor de Aplicaciones" {
				    containerInstance webapp
					containerInstance servicios
					
				}
				deploymentNode "PostgreSQL" "Contenedor de DB" {
				    containerInstance database
				}
            }
        }

        deploymentEnvironment "Cloud" {
            deploymentNode "Amazon Web Services" {
                tags "Amazon Web Services - Cloud"
                deploymentNode "Amazon OpenSearch" {
					tags "Amazon Web Services - OpenSearch Service"
                    containerInstance webapp
					containerInstance servicios
					
				}
				deploymentNode "Amazon RDS" {
				    tags "Amazon Web Services - RDS"
				    deploymentNode "Amazon Aurora" {
				        tags "Amazon Web Services - Aurora MySQL Instance"
				        containerInstance database
				    }
				}
            }
        }

        deploymentEnvironment "MVC" {
            deploymentNode "Servidor App" "server1" "Windows, Linux o Mac" "" 2 {
                deploymentNode "Tomcat" "Servidor de Aplicaciones" {
					containerInstance webapp
				}
			}
			deploymentNode "Servidor Negocio" "server2" "Windows, Linux o Mac" "" 2 {
                deploymentNode "JBoss" "Servidor de Negocio" {
					containerInstance servicios
				}
			}
			deploymentNode "Servidor DB" "server3" "Windows, Linux o Mac" "" 2 {
            	deploymentNode "MariaDB" "Servidor de DB" {
					containerInstance database
				}
            }
        }
        
        deploymentEnvironment "MicroServicios" {
            si1 = deploymentGroup "Service instance 1"
            si2 = deploymentGroup "Service instance 2"
            si3 = deploymentGroup "Service instance 3"
            si4 = deploymentGroup "Service instance 4"
            
            deploymentNode "Equipo escritorio" "desk" "Windows, Linux o Mac" "" {
                containerInstance desk si1,si2,si3,si4
            }
            
            deploymentNode "Tablet" "tablet" "Windows, Linux o Mac" "" {
                containerInstance tablet si1,si2,si3,si4
            }
            
            deploymentNode "Celular" "cel" "Windows, Linux o Mac" "" {
                containerInstance mobile si1,si2,si3,si4
            }
            
            deploymentNode "Servidor MsVentas" "ms1" "Windows, Linux o Mac" "" {
                deploymentNode "JBoss" "Servidor de Negocio" {
					containerInstance servicios si1 {
					    description "MicroServicio Ventas"
					}
				}
            	deploymentNode "SQLite" "Servidor de DB" {
					containerInstance database si1
				}
			}
			
            deploymentNode "Servidor MsUsuarios" "ms2" "Windows, Linux o Mac" "" {
                deploymentNode "JBoss" "Servidor de Negocio" {
					containerInstance servicios si2 {
					    description "MicroServicio Usuarios"
					}
				}
            	deploymentNode "SQLite" "Servidor de DB" {
					containerInstance database si2
				}
			}
			
            deploymentNode "Servidor MsRecomendador" "ms3" "Windows, Linux o Mac" "" {
                deploymentNode "JBoss" "Servidor de Negocio" {
					containerInstance servicios si3 {
					    description "MicroServicio Recomendador"
					}
				}
            	deploymentNode "SQLite" "Servidor de DB" {
					containerInstance database si3
				}
			}
			
            deploymentNode "Servidor MsReportes" "ms4" "Windows, Linux o Mac" "" {
                deploymentNode "JBoss" "Servidor de Negocio" {
					containerInstance servicios si4 {
					    description "MicroServicio Reportes"
					}
				}
            	deploymentNode "SQLite" "Servidor de DB" {
					containerInstance database si4
				}
			}
        }
        
        deploymentEnvironment "Prod" {
            deploymentNode "FW" "FW" {
                firewall = infrastructureNode firewall "Firewall"
            }
            
            deploymentNode "B1" "B1" {
                webBalancer = infrastructureNode balancer "Balanceador"{
                    firewall -> this "Redirecciona" "Http"
                }
            }
            
            psi1 = deploymentGroup "Service instance 1"
            psi2 = deploymentGroup "Service instance 2"
            
            deploymentNode "Servidor App1" "serverA1" "Windows, Linux o Mac" {
                deploymentNode "Tomcat" "Servidor de Aplicaciones" {
					wa1 = containerInstance webapp psi1
					webBalancer -> this "Balancea" "Http"
				}
				
			}
            deploymentNode "Servidor App2" "serverA2" "Windows, Linux o Mac" {
                deploymentNode "Tomcat" "Servidor de Aplicaciones" {
					wa2 = containerInstance webapp psi2
					webBalancer -> this "Balancea" "Http"
				}
			}
			deploymentNode "Servidor Negocio1" "serverS1" "Windows, Linux o Mac" {
                deploymentNode "JBoss" "Servidor de Negocio" {
					containerInstance servicios psi1
				}
			}
			deploymentNode "Servidor Negocio2" "serverS2" "Windows, Linux o Mac" {
                deploymentNode "JBoss" "Servidor de Negocio" {
					containerInstance servicios psi2
				}
			}
			deploymentNode "Servidor DB1" "serverDB1" "Windows, Linux o Mac" {
            	deploymentNode "MariaDB" "Servidor de DB" {
					containerInstance database psi1
				}
            }
            deploymentNode "Servidor DB2" "serverDB2" "Windows, Linux o Mac" {
            	deploymentNode "MariaDB" "Servidor de DB" {
					containerInstance database psi2
				}
            }
        }
    }
    
    views {

        properties {
            "plantuml.url" "https://plantuml.com/plantuml"
            "mermaid.url" "https://mermaid.ink"
            #"mermaid.format" "svg"
            "kroki.url" "https://kroki.io"
            #"kroki.format" "svg"
        }

        systemLandscape "Landscape" "Diagrama de landscape" {
            include *
            autoLayout tb
        }
        systemContext sistema "Contexto" "Diagrama de contexto del sistema" {
            include *
            autoLayout tb
        }
        container sistema "Contenedores" "Contenedores del sistema" {
            include *
            autoLayout tb
        }
        component webapp "ComponentesWeb" "Componentes Web" {
            include *
            autoLayout tb
        }
        component servicios "ComponentesServicios" "Componentes de Servicios" {
            include *
            autoLayout tb
        }
        deployment sistema "Cloud" "Cloud" "Despliegue sugerido en Cloud"{
            include *
            autoLayout lr
        }
        deployment sistema "Monolito" "Monolito" "Despliegue sugerido en estilo Monolítico"{
            include *
            autoLayout lr
        }
        deployment sistema "MVC" "MVC" "Despliegue sugerido en estilo MVC"{
            include *
            autoLayout lr
        }
        deployment sistema "MicroServicios" "MicroServicios" "Despliegue sugerido en Microservicios"{
            include *
            autoLayout lr
        }
        deployment sistema "Prod" "Produccion" "Despliegue sugerido en producción"{
            include *
            autoLayout lr
        }
        image database "ER1" {
            image MER-APP_BASE.png
            title "Entidad Relación"
        }

        image database "ER2" {
            image https://upload.wikimedia.org/wikipedia/commons/thumb/7/72/ER_Diagram_MMORPG.png/673px-ER_Diagram_MMORPG.png
            title "Entidad Relación 2"
        }

        image database "PlantUML" {
            plantuml seq.plant
            title "PlantUML Sequence"
        } 

        image database "Mermaid" {
            mermaid graph.mmd
            title "Mermaid Graph"
        }

        image database "Kroki" {
            kroki erd erd.krk
            title "Kroki ERD"
        }
        
        themes https://static.structurizr.com/themes/amazon-web-services-2020.04.30/theme.json
        themes https://static.structurizr.com/themes/amazon-web-services-2023.01.31/theme.json

        styles {
            theme default
            
            element "Component" {
                shape Component
            }
            element "db" {
                shape Cylinder
            }
            element "Robot" {
                shape Robot
            }
            element "Desktop" {
                shape Window
            }
            element "Browser" {
                shape WebBrowser
            }
            element "Tablet" {
                shape MobileDeviceLandscape
            }
            element "Mobile" {
                shape MobileDevicePortrait
            }
            element "Existing System" {
                background #999999
                color #ffffff
            }
            element "Posterior" {
                opacity 30
                description false
            }
        }
    }

    !plugin plantuml.PlantUMLEncoderPlugin {
        "plantuml.url" "https://www.plantuml.com/plantuml"
    }

    !plugin mermaid.MermaidEncoderPlugin {
        "mermaid.url" "https://mermaid.ink"
        #"mermaid.format" "png"
    }

    #Este plugin aún no existe
    #!plugin kroki.KrokiEncoderPlugin {
    #    "kroki.url" "https://kroki.io"
    #}
}
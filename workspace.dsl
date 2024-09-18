workspace "Taller" "Ejemplo de clase" {

    model {
        properties {
            "structurizr.groupSeparator" "/"
        }
        usuarios = group usuarios {
            usuario = person "Usuario general"
            admin = person "Administrador"
        }
            
        sistema = softwareSystem "Bartech" "Bartech software" {
            usuario -> this "Usa"
            admin -> this "Usa"
            !docs docs
            !adrs adrs

            
            
            webapp = container "Aplicación Web" "" "" "Browser" {
                usuario -> this "Usa"
                admin -> this "Usa"

                usuariosComp = component componenteUsuarios "usuarios" "php"
                autenticacionComp = component componenteAutenticacion "autenticacion" "push"
                pubComp = component componenteBares "bares" "LeafLet"
                cancionesComp = component componenteCanciones "canciones" "Google Charts"
                
            
        
            }
        
            servicios = container "Servicios"{
                apiGateway = component gateway "Servicio de gateway" "Java"
                authServ = component autenticacion "Servicio de autenticacion" "Java"
                usuariosServ = component usuarios "Servicio de usuarios" "Java"
                pubServ = component bares "Servicio de bares" "Java"
                songServ = component canciones "Servicio de canciones" "Java"
                
                apiGateway -> authServ "Valida" "Http"
                apiGateway -> usuariosServ "Redirecciona" "Http"
                apiGateway -> pubServ "Redirecciona" "Http"
                apiGateway -> songServ "Redirecciona" "Http"
                usuariosComp -> apiGateway "Consume" "restFul"
            }
            database = container "DB" "Base de datos de ejemplo" "Schema Relacional" "db" {
				servicios -> this "Persiste en" "JNDI"
			}
        }
        
        ext = softwareSystem "Youtube" "Sistema externo" "Existing System"{
            sistema -> this "Redirecciona"
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
                    containerInstance webapp "" "Posterior"
					containerInstance servicios "" "Posterior"
					
				}
				deploymentNode "Amazon RDS" {
				    tags "Amazon Web Services - RDS"
				    deploymentNode "Amazon Aurora" {
				        tags "Amazon Web Services - Aurora MySQL Instance"
				        containerInstance database "" "Posterior"
				    }
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
        image database "ER1" {
            image MER.png
            title "Entidad Relación"
        }

        image database "PlantUML" {
            plantuml seq.plant
            title "Entidad relacion plantUML"
        } 

        image database "Mermaid" {
            mermaid flujo-pre.mmd
            title "Flujo sin bartech (As Is)"
        }

        image database "Mermaid2" {
            mermaid flujo-pos.mmd
            title "Flujo bartech (To be)"
            description "Diagrama de flujo una vez implementado el software"
        }
        
        image database "Mermaid3" {
            mermaid class.mmd
            title "Diagrama de clases"
        }

        image database "Login" {
            image login.png
            title "Vista login"
            description "Login de usuarios"
        }

        image database "Register" {
            image register.png
            title "Vista registro"
            description "Registro de usuarios"
        }

        image database "Home" {
            image home.png
            title "Vista principal"
            description "Vista una vez logeado el usuario"
        }

        image database "Songs" {
            image songs.png
            title "Vista playlist"
            description "Vista del playlist cuando se selecciona un bar"
        }

        image database "Request" {
            image request.png
            title "Vista peticion de musica"
            description "Vista del usuario general cuando quiere solicitar una cancion"
        }

        image database "Report" {
            image reporte1.png
            title "Vista canciones mas sonadas"
            description "Vista del usuario Administrador para saber las canciones mas sonadas"
        }

        image database "Update" {
            image update.png
            title "Vista actualizar informacion del bar"
            description "Vista del usuario Administrador para actualizar la informacion del bar"
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
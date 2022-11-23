workspace amarillo_deployment {
  model {
     amarillo = softwareSystem amarillo {
       amarillo_stack = container "Amarillo Stack"
       github_actions = container "Github Actions"
       remote_git_repository = container "Remote Git Repository"
       local_git_repository = container "Local Repository Clone" 
       image_registry = container "Docker Image Registry" "registry.gitlab.tpwd.de"
    }
    github_actions -> amarillo_stack "creates/updates"
    github_actions -> image_registry "builds and pushes new images"
    amarillo_stack -> image_registry "pulls images"
    local_git_repository -> remote_git_repository "push"
    remote_git_repository -> github_actions "triggers"

    deploymentEnvironment "Live" {

      deploymentNode "Planetary Networks" "" "tpwd-bb-navi.customer.planetary-quantum.net" "" {
        deploymentNode "Swarm Worker" "Docker" "" "" {
          containerInstance amarillo_stack "bbnavi Datahub"
        }
      }
      deploymentNode "Github" {
        containerInstance github_actions
        containerInstance remote_git_repository
      }
      deploymentNode "Developers Machine" {
        containerInstance local_git_repository
      }
      deploymentNode "Gitlab" {
        containerInstance image_registry 
      }
    }
  }

  views {
    deployment amarillo "Live" "LiveDeployment" {
      include *
      autoLayout
    }

  }
}

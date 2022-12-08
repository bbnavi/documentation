workspace standard_deployment {
  model {
     deployment_system = softwareSystem deployment_system {
       stack = container "Stack" "This deployment diagram is the same for any of the following stacks: bbnavi Datahub, bbnavi Datahub CMS, commonsbookings2gbfs, moqo2gbfs, opentripplaner, amarillo, gtfs-rt-feed, bbnavi-datahub-tmb-importer"
       github_actions = container "Github Actions"
       remote_git_repository = container "Remote Git Repository"
       local_git_repository = container "Local Repository Clone"
       image_registry = container "Docker Image Registry" "registry.gitlab.tpwd.de"
    }
    github_actions -> stack "creates/updates"
    github_actions -> image_registry "builds and pushes new images"
    stack -> image_registry "pulls images"
    local_git_repository -> remote_git_repository "push"
    remote_git_repository -> github_actions "triggers"

    deploymentEnvironment "Live" {

      deploymentNode "Planetary Networks" "" "tpwd-bb-navi.customer.planetary-quantum.net" "" {
        deploymentNode "Swarm Worker" "Docker" "" "" {
          containerInstance stack "bbnavi Datahub"
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
    deployment deployment_system "Live" "LiveDeployment" {
      include *
      autoLayout
    }

  }
}

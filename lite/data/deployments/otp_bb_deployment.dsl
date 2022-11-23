workspace otp_bb_deployment {
  model {
     otp_bb = softwareSystem otp_bb {
      otp_bb_stack = container "OTP Berlin Brandenburg Stack"
      github_actions = container "Github Actions"
      remote_git_repository = container "Remote Git Repository"
      local_git_repository = container "Local Repository Clone" 
      image_registry = container "Docker Image Registry" "registry.gitlab.tpwd.de"
    }
    github_actions -> otp_bb_stack "creates/updates"
    github_actions -> image_registry "builds and pushes new images"
    otp_bb_stack -> image_registry "pulls images"
    local_git_repository -> remote_git_repository "push"
    remote_git_repository -> github_actions "triggers"

    deploymentEnvironment "Live" {

      deploymentNode "Planetary Networks" "" "tpwd-bb-navi.customer.planetary-quantum.net" "" {
        deploymentNode "Swarm Worker" "Docker" "" "" {
          containerInstance otp_bb_stack "bbnavi Datahub"
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
    deployment otp_bb "Live" "LiveDeployment" {
      include *
      autoLayout
    }
  }
}

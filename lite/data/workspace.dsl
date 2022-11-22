/*
 * This is a combined version of the following workspaces:
 *
 * - "Big Bank plc - System Landscape" (https://structurizr.com/share/28201/)
 * - "Big Bank plc - Internet Banking System" (https://structurizr.com/share/36141/)
*/
workspace {
  model {
     test = softwareSystem test {
      stack = container stack 
      githubActions = container "Github Actions"
      remoteGitRepository = container "Remote Git Repository"
      localGitRepository = container "Local Repository Clone" 
      imageRegistry = container "Docker Image Registry" "registry.gitlab.tpwd.de"
    }
    githubActions -> Stack "creates"
    githubActions -> imageRegistry "builds and pushes new images"
    stack -> imageRegistry "pulls images"
    localGitRepository -> remoteGitRepository "push"
    remoteGitRepository -> githubActions "triggers"

    deploymentEnvironment "Live" {

      deploymentNode "Planetary Networks" "" "tpwd-bb-navi.customer.planetary-quantum.net" "" {
        deploymentNode "Swarm Worker" "Docker" "" "" {
          containerInstance stack  "bbnavi Datahub" {

          }
        }
      }
      deploymentNode "Github" {
        containerInstance githubActions
        containerInstance remoteGitRepository
      }
      deploymentNode "Developers Machine" {
        containerInstance localGitRepository
      }
      deploymentNode "Gitlab" {
        containerInstance imageRegistry 
      }
    }
  }

  views {
    deployment test "Live" "LiveDeployment" {
      include *
      autoLayout
    }

  }
}

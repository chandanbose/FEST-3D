module sa_gradients
  !---------------------------------------------------------------
  ! 1705009  Jatinder Pal Singh Sandhu
  !          - first build
  ! aim : link sst pointer to allocated memory for gradients
  !---------------------------------------------------------------

  use global_vars,  only : imx
  use global_vars,  only : jmx
  use global_vars,  only : kmx
  use global_vars,  only : gradqp_x
  use global_vars,  only : gradqp_y
  use global_vars,  only : gradqp_z

  use global_vars,  only : gradtv_x
  use global_vars,  only : gradtv_y
  use global_vars,  only : gradtv_z 
  use utils,        only : dmsg
  implicit none
  private

  public :: setup_sa_grad
  public :: destroy_sa_grad

  contains

    subroutine setup_sa_grad()
      implicit none

      call dmsg(1, 'gradients', 'setup_sa_grad')

      gradtv_x(0:imx, 0:jmx, 0:kmx) => gradqp_x(:, :, :, 5)
      gradtv_y(0:imx, 0:jmx, 0:kmx) => gradqp_y(:, :, :, 5)
      gradtv_z(0:imx, 0:jmx, 0:kmx) => gradqp_z(:, :, :, 5)

    end subroutine setup_sa_grad


    subroutine destroy_sa_grad()
      implicit none

      call dmsg(1, 'gradients', 'destroy_sa_grad')

      nullify(gradtv_x)
      nullify(gradtv_y)
      nullify(gradtv_z)

    end subroutine destroy_sa_grad


end module sa_gradients

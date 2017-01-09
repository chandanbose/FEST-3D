module global_vars
  !----------------------------------------------
  ! contains all the public/global variables used 
  ! by more than one module
  !----------------------------------------------

  use global, only : INTERPOLANT_NAME_LENGTH
  use global, only : FORMAT_LENGTH
  use global, only : SCHEME_NAME_LENGTH
  use global, only : FILE_NAME_LENGTH

  implicit none
  public

  ! Parallel processig variables
  integer :: total_process      ! total no. of process to be used for computation
  integer :: total_entries      ! total enteries in layout.md for each processor
  integer :: process_id         ! id no. of each processor
  integer :: imin_id            ! bc_list at imin for particulat processor
  integer :: imax_id            ! bc_list at imax for particulat processor
  integer :: jmin_id            ! bc_list at jmin for particulat processor
  integer :: jmax_id            ! bc_list at jmax for particulat processor
  integer :: kmin_id            ! bc_list at kmin for particulat processor
  integer :: kmax_id            ! bc_list at kmax for particulat processor

  ! Time controls
  integer :: min_iter=1         !Minimum iteration value, starting iteration value
  integer :: max_iters          !Maximum iteration value, stop at
  integer :: start_from=0       ! folder load level from time_directories eg 1 for folder 0001
  integer :: checkpoint_iter    ! Write interval for output file
  integer :: checkpoint_iter_count ! write file counter
  integer :: current_iter       ! current iteration number

  !write controls
  integer :: res_write_interval                      ! resnorm write interval
  integer :: purge_write                             ! number of output files per process to keep
  integer :: write_percision                         ! number of place after decimal 
  character(len=FORMAT_LENGTH):: write_data_format   ! either ascii or binary
  character(len=FORMAT_LENGTH):: write_file_format   ! either vtk or tecplot
  character(len=FILE_NAME_LENGTH):: outfile          ! name of output file

  ! solver specific
  real :: CFL                  ! courrent number
  real :: tolerance            ! minimum value of resnorm after which simulation stop

  !solver time secific
  character                                 :: time_stepping_method  ! local or global
  character(len=INTERPOLANT_NAME_LENGTH)    :: time_step_accuracy    ! Ranga-Kutta 4th order or first order
  real                                      :: global_time_step      ! value of global time step
  real, dimension(:, :, :), allocatable     :: delta_t               ! time increment value
  real                                      :: sim_clock             

  !scheme
  character(len=SCHEME_NAME_LENGTH) :: scheme_name         !flux calculation -> ausm, ldfss0, vanleer
  character(len=INTERPOLANT_NAME_LENGTH) :: interpolant    !face state reconstruction -> muscl, ppm, none

  !solution specific (used for Ranga_kutta_4th order)
  real, dimension(:, :, :, :), allocatable  :: qp_n
  real, dimension(:, :, :, :), allocatable  :: dEdx_1
  real, dimension(:, :, :, :), allocatable  :: dEdx_2
  real, dimension(:, :, :, :), allocatable  :: dEdx_3

  ! state variables viscous
  integer                                           :: n_var        ! number of variable to solve for
  real, dimension(:, :, :, :), allocatable, target  :: qp           ! primitive variable at cell center
  real, dimension(:)         , allocatable, target  :: qp_inf       ! primitive variable at infinity
  real, dimension(:, :, :)                , pointer :: density      ! rho pointer, point to slice of qp
  real, dimension(:, :, :)                , pointer :: x_speed      ! u pointer, point to slice of qp
  real, dimension(:, :, :)                , pointer :: y_speed      ! v pointer, point to slice of qp
  real, dimension(:, :, :)                , pointer :: z_speed      ! w pointer, point to slice of qp
  real, dimension(:, :, :)                , pointer :: pressure     ! P pointer, point to slice of qp
  real                                    , pointer :: density_inf  ! rho pointer, point to slice of qp_inf
  real                                    , pointer :: x_speed_inf  ! u pointer, point to slice of qp_inf
  real                                    , pointer :: y_speed_inf  ! v pointer, point to slice of qp_inf
  real                                    , pointer :: z_speed_inf  ! w pointer, point to slice of qp_inf
  real                                    , pointer :: pressure_inf ! p pointer, point to slice of qp_inf

  ! Freestram variable used to read file before inf pointer are linked and allocated
  real                                              :: free_stream_density  ! read Rho_inf from control file
  real                                              :: free_stream_x_speed  ! read U_inf from control file
  real                                              :: free_stream_y_speed  ! read V_inf from control file
  real                                              :: free_stream_z_speed  ! read W_inf from control file
  real                                              :: free_stream_pressure ! read P_inf from control file
  real                                              :: free_stream_tk       ! read tk_inf from control file
  real                                              :: free_stream_tw       ! read tw_inf from control file
  real, dimension(:, :, :), allocatable             :: dist      ! wall distance for each cell center

  ! state variable turbulent
  integer                                           :: sst_n_var=2
!  real, dimension(:, :, :, :), allocatable, target  :: tqp       ! turbulent primitive
!  real, dimension(:)         , allocatable, target  :: tqp_inf   ! turbulent primitive at inf
  real, dimension(:, :, :)                , pointer :: tk        ! TKE/mass
  real, dimension(:, :, :)                , pointer :: tw        ! omega
  real                                    , pointer :: tk_inf    ! TKE/mass at inf
  real                                    , pointer :: tw_inf    ! omega at inf

  ! residue variables
  real, dimension(:, :, :, :)             , pointer :: F_p
  real, dimension(:, :, :, :)             , pointer :: G_p
  real, dimension(:, :, :, :)             , pointer :: H_p
  real, dimension(:, :, :)                , pointer :: mass_residue
  real, dimension(:, :, :)                , pointer :: x_mom_residue
  real, dimension(:, :, :)                , pointer :: y_mom_residue
  real, dimension(:, :, :)                , pointer :: z_mom_residue
  real, dimension(:, :, :)                , pointer :: energy_residue
  real, dimension(:, :, :)                , pointer :: TKE_residue
  real, dimension(:, :, :)                , pointer :: omega_residue

  ! thermal properties
  real                                              :: gm    !gamma
  real                                              :: R_gas !univarsal gas constant
  
  ! Transport properties
  real                                              :: mu_ref !viscoity

  ! sutherland law variable
  real                                              :: T_ref
  real                                              :: Sutherland_temp

  ! nondimensional numbers
  real                                              :: Pr !prandtl number

  ! switches
  logical                                           :: supersonic_flag
  integer                                           :: ilimiter_switch
  integer                                           :: PB_switch
  character(len=5)                                  :: turbulence ! todo character length
  

  !residual specific
  real, pointer ::        resnorm     !            residue normalized
  real, pointer ::    vis_resnorm     ! {rho+V+P}  residue normalized
  real, pointer ::   turb_resnorm     !  turbulent residue normalized
  real, pointer ::   cont_resnorm     !       mass residue normalized
  real, pointer ::  x_mom_resnorm     ! x momentum residue normalized
  real, pointer ::  y_mom_resnorm     ! Y momentum residue normalized
  real, pointer ::  z_mom_resnorm     ! Z momentum residue normalized
  real, pointer :: energy_resnorm     !     energy residue normalized
  real, pointer ::    TKE_resnorm     !        TKE residue normalized
  real, pointer ::  omega_resnorm     !      omega residue normalized
  real, pointer ::        resnorm_d1  !            residue normalized/same at iter 1
  real, pointer ::    vis_resnorm_d1  ! {rho+V+P}  residue normalized/same at iter 1
  real, pointer ::   turb_resnorm_d1  !  turbulent residue normalized/same at iter 1 
  real, pointer ::   cont_resnorm_d1  !       mass residue normalized/same at iter 1
  real, pointer ::  x_mom_resnorm_d1  ! x momentum residue normalized/same at iter 1
  real, pointer ::  y_mom_resnorm_d1  ! Y momentum residue normalized/same at iter 1
  real, pointer ::  z_mom_resnorm_d1  ! Z momentum residue normalized/same at iter 1
  real, pointer :: energy_resnorm_d1  !     energy residue normalized/same at iter 1
  real, pointer ::    TKE_resnorm_d1  !        TKE residue normalized/same at iter 1
  real, pointer ::  omega_resnorm_d1  !      omega residue normalized/same at iter 1
  real          ::        resnorm_0   !            residue normalized at iter 1
  real          ::    vis_resnorm_0   ! {rho+V+P}  residue normalized at iter 1
  real          ::   turb_resnorm_0   !  turbulent residue normalized at iter 1 
  real          ::   cont_resnorm_0   !       mass residue normalized at iter 1
  real          ::  x_mom_resnorm_0   ! x momentum residue normalized at iter 1
  real          ::  y_mom_resnorm_0   ! Y momentum residue normalized at iter 1
  real          ::  z_mom_resnorm_0   ! Z momentum residue normalized at iter 1
  real          :: energy_resnorm_0   !     energy residue normalized at iter 1
  real          ::    TKE_resnorm_0   !        TKE residue normalized at iter 1
  real          ::  omega_resnorm_0   !      omega residue normalized at iter 1
  real          ::        resnorm_0s  !            residue normalized at iter 1 used for mpi manipulation
  real          ::    vis_resnorm_0s  ! {rho+V+P}  residue normalized at iter 1 used for mpi manipulation
  real          ::   turb_resnorm_0s  !  turbulent residue normalized at iter 1 used for mpi manipulation 
  real          ::   cont_resnorm_0s  !       mass residue normalized at iter 1 used for mpi manipulation
  real          ::  x_mom_resnorm_0s  ! x momentum residue normalized at iter 1 used for mpi manipulation
  real          ::  y_mom_resnorm_0s  ! Y momentum residue normalized at iter 1 used for mpi manipulation
  real          ::  z_mom_resnorm_0s  ! Z momentum residue normalized at iter 1 used for mpi manipulation
  real          :: energy_resnorm_0s  !     energy residue normalized at iter 1 used for mpi manipulation
  real          ::    TKE_resnorm_0s  !        TKE residue normalized at iter 1 used for mpi manipulation
  real          ::  omega_resnorm_0s  !      omega residue normalized at iter 1 used for mpi manipulation

  ! grid variables
  integer                                 :: imx, jmx, kmx        ! no. of points
  real, dimension(:, :, :), allocatable  :: grid_x, grid_y, grid_z! point coordinates

  ! geometry variables
  real, dimension(:, :, :), allocatable, target :: xnx, xny, xnz !face unit norm x
  real, dimension(:, :, :), allocatable, target :: ynx, yny, ynz !face unit norm y
  real, dimension(:, :, :), allocatable, target :: znx, zny, znz !face unit norm z
  real, dimension(:, :, :), allocatable, target :: xA, yA, zA    !face area
  real, dimension(:, :, :), allocatable, target :: volume
  real, dimension(:, :, :), allocatable, target ::   left_ghost_centroid
  real, dimension(:, :, :), allocatable, target ::  right_ghost_centroid
  real, dimension(:, :, :), allocatable, target ::  front_ghost_centroid
  real, dimension(:, :, :), allocatable, target ::   back_ghost_centroid
  real, dimension(:, :, :), allocatable, target ::    top_ghost_centroid
  real, dimension(:, :, :), allocatable, target :: bottom_ghost_centroid

end module global_vars

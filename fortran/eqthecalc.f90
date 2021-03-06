! Theta-e
!NCLFORTSTART
SUBROUTINE DEQTHECALC(qvp, tmk, prs, eth, miy, mjx, mkzh)
    USE wrf_constants, ONLY : EPS, GAMMA, GAMMAMD, TLCLC1, TLCLC2, TLCLC3, TLCLC4, &
                          THTECON1, THTECON2, THTECON3

    IMPLICIT NONE

    !f2py threadsafe
    !f2py intent(in,out) :: eth

    ! Input variables
    ! Sizes
    INTEGER,INTENT(IN) :: miy, mjx, mkzh
    ! Qvapor [g/kg]
    REAL(KIND=8), DIMENSION(miy,mjx,mkzh), INTENT(IN) :: qvp
    ! Temperature [K]
    REAL(KIND=8), DIMENSION(miy,mjx,mkzh), INTENT(IN) :: tmk
    ! full pressure (=P+PB) [hPa]
    REAL(KIND=8), DIMENSION(miy,mjx,mkzh), INTENT(IN) :: prs
    ! Output variable
    ! equivalent potential temperature [K]
    REAL(KIND=8), DIMENSION(miy,mjx,mkzh), INTENT(OUT) :: eth

!NCLEND

    ! local variables
    REAL(KIND=8) :: q
    REAL(KIND=8) :: t
    REAL(KIND=8) :: p
    REAL(KIND=8) :: e
    REAL(KIND=8) :: tlcl
    INTEGER :: i, j, k

    DO k = 1,mkzh
        DO j = 1,mjx
            DO i = 1,miy
                q = MAX(qvp(i,j,k), 1.D-15)
                t = tmk(i,j,k)
                p = prs(i,j,k)/100.
                e = q*p/(EPS + q)
                tlcl = TLCLC1/(LOG(t**TLCLC2/e) - TLCLC3) + TLCLC4
                eth(i,j,k) = t*(1000.D0/p)**(GAMMA*(1.D0 + GAMMAMD*q))* &
                        EXP((THTECON1/tlcl - THTECON2)*q*(1.D0 + THTECON3*q))
            END DO
        END DO
    END DO

    RETURN

END SUBROUTINE DEQTHECALC

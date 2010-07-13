/**
 * @author  Brano Kusy
 */

configuration ResetC {
  provides interface Reset;
}

implementation {
	components RealMainP, ResetP;
	RealMainP.PlatformInit -> ResetP;
	Reset = ResetP;
}

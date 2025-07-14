CREATE PROCEDURE [dbo].[spCI_Regularizar02CrearFotos]
	@IdDeclarante SMALLINT
	,@SkIdBatch INT 
	,@FechaDatos DATE
	,@OpcionRegularizar VARCHAR(1)
	,@Sesion CHAR(4)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON;
	DECLARE @VersionProcedimiento INT = 32
	,@RespuestaXml VARCHAR(MAX) = ''
	,@ListaHistoricos VARCHAR(MAX) = ''
	,@UltimaSecuencia INT = 0
	--TRACE -- MEDICON:
	,@Tarea VARCHAR(50) = OBJECT_NAME(@@PROCID)

	BEGIN TRY
		
		-- CREAR DBG_ADICIONALES
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DBG' AND AbreviaturaHistorico = 'ADI') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DBG_ADICIONALES'

			SET @ListaHistoricos += ',DBG_ADICIONALES'

			INSERT INTO fci.DBG_ADICIONALES
			SELECT 
			H.SkMasterDBG
			,IDEntrada = @SkIdBatch
			,SECEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,FechaEnVigor = @FechaDatos
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,FechaProceso = NULL
			,IDRespuesta = 0
			,SECRespuesta = 0
			,ListaCodigosSituacion = ''
			,Asimilado = 0
			,H.CodigoGarantia
			,H.FechaConstruccion
			,H.FechaUltimaRehabilitacion
			,H.EstadoConstruccion
			,H.Licencia
			,H.ViviendaHabitual
			,H.ValorTerrenoAjustado
			,H.NumeroViviendas
			,H.TipoSuelo
			,H.DesarrolloPlaneamiento
			,H.SistemaGestion
			,H.FaseGestion
			,H.ParalizacionUrbanizacion
			,H.PorcentajeEjecutado
			,H.PorcentajeValorado
			,H.ProximidadNucleoUrbano
			,H.ProyectoObra
			,H.SuperficieTerreno
			,H.Aprovechamiento
			,H.ProductoADesarrollar
			,H.ExpectativaUrbanistica
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DBG_MASTER AS M
					ON M.SkMasterDBG = R.SkMaster
				INNER JOIN fci.DBG_ADICIONALES AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE Master = 'DBG'
				AND R.AbreviaturaHistorico = 'ADI'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DBG - ADI'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DBG_MASTER AS M
				INNER JOIN fci.DBG_ADICIONALES AS H
					ON H.SkMasterDBG = M.SkMasterDBG
			WHERE H.IDEntrada = @SkIdBatch

		END

		-- CREAR DBG_FINANCIEROS
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DBG' AND AbreviaturaHistorico = 'AFI') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DBG_FINANCIEROS'

			SET @ListaHistoricos += ',DBG_FINANCIEROS'

			INSERT INTO fci.DBG_FINANCIEROS
			SELECT 
			H.SkMasterDBG
			,IDEntrada = @SkIdBatch
			,SECEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,FechaEnVigor = @FechaDatos
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,FechaProceso = NULL
			,IDRespuesta = 0
			,SECRespuesta = 0
			,ListaCodigosSituacion = ''
			,Asimilado = 0
			,H.CodigoGarantia
			,H.SkPersona
			,H.CodigoPersonaEmisor
			,H.IdPersona
			,H.CodigoValor
			,H.Cotizacion
			,H.Nominal
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DBG_MASTER AS M
					ON M.SkMasterDBG = R.SkMaster
				INNER JOIN fci.DBG_FINANCIEROS AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
 			WHERE Master = 'DBG'
				AND R.AbreviaturaHistorico = 'AFI'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DBG - AFI'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DBG_MASTER AS M
				INNER JOIN fci.DBG_FINANCIEROS AS H
					ON H.SkMasterDBG = M.SkMasterDBG
			WHERE H.IDEntrada = @SkIdBatch
		END

		-- CREAR DBG_GARANTIAS
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DBG' AND AbreviaturaHistorico = 'GAR') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DBG_GARANTIAS'

			SET @ListaHistoricos += ',DBG_GARANTIAS'

			INSERT INTO fci.DBG_GARANTIAS
			SELECT 
			H.SkMasterDBG
			,IDEntrada = @SkIdBatch
			,SECEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,FechaEnVigor = @FechaDatos
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,FechaProceso = NULL
			,IDRespuesta = 0
			,SECRespuesta = 0
			,ListaCodigosSituacion = ''
			,Asimilado = 0
			,H.CodigoGarantia
			,H.TipoGarantia
			,H.TipoActivo
			,H.AlcanceGarantiaReal
			,H.CodigoGarantiaMaximo
			,H.OrdenPrelacion
			,H.SkPersonaProveedor
			,H.CodigoPersonaProveedor
			,H.IdPersonaProveedor
			,H.ValorGarantia
			,H.TipoValor
			,H.MetodoValoracion
			,H.FechaValor
			,H.FechaVencimiento
			,H.ValorOriginal
			,H.FechaValorOriginal
			,EntidadQueDeclaro = 0
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DBG_MASTER AS M
					ON M.SkMasterDBG = R.SkMaster
				INNER JOIN fci.DBG_GARANTIAS AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DBG'
				AND R.AbreviaturaHistorico = 'GAR'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DBG - GAR'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DBG_MASTER AS M
				INNER JOIN fci.DBG_GARANTIAS AS H
					ON H.SkMasterDBG = M.SkMasterDBG
			WHERE H.IDEntrada = @SkIdBatch
		END

		-- CREAR DBG_INMUEBLES
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DBG' AND AbreviaturaHistorico = 'INM') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DBG_INMUEBLES'

			SET @ListaHistoricos += ',DBG_INMUEBLES'

			INSERT INTO fci.DBG_INMUEBLES
			SELECT 
			H.SkMasterDBG
			,IDEntrada = @SkIdBatch
			,SECEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,FechaEnVigor = @FechaDatos
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,FechaProceso = NULL
			,IDRespuesta = 0
			,SECRespuesta = 0
			,ListaCodigosSituacion = ''
			,Asimilado = 0
			,H.CodigoGarantia
			,H.ConsideracionInmueble
			,H.Pais
			,H.CodigoPostal
			,H.InmuebleVariasFincas
			,H.IDUFIR
			,H.IRProvincia
			,H.IRMunicipio
			,H.IRNumero
			,H.IRTomo
			,H.IRLibro
			,H.IRNumeroFinca
			,H.ReferenciaCatastral
			,H.CargasPrevias
			,H.PrincipalRH
			,H.InteresesRH
			,H.PromocionInmobiliaria
			,H.NUT
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DBG_MASTER AS M
					ON M.SkMasterDBG = R.SkMaster
				INNER JOIN fci.DBG_INMUEBLES AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DBG'
				AND R.AbreviaturaHistorico = 'INM'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DBG - INM'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DBG_MASTER AS M
				INNER JOIN fci.DBG_INMUEBLES AS H
					ON H.SkMasterDBG = M.SkMasterDBG
			WHERE H.IDEntrada = @SkIdBatch
		END

		-- CREAR DBG_RELACIONES
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DBG' AND AbreviaturaHistorico = 'REL') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DBG_RELACIONES'

			SET @ListaHistoricos += ',DBG_RELACIONES'

			INSERT INTO fci.DBG_RELACIONES
			SELECT 
			H.SkMasterDBG
			,IDEntrada = @SkIdBatch
			,SECEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,FechaEnVigor = @FechaDatos
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,FechaProceso = NULL
			,IDRespuesta = 0
			,SECRespuesta = 0
			,ListaCodigosSituacion = ''
			,Asimilado = 0
			,H.CodigoGarantia
			,H.IdCuenta
			,H.SkOperacion
			,H.CodigoOperacion
			,H.EntidadQueDeclaro
			,H.GarantiaRealPrincipal
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DBG_MASTER AS M
					ON M.SkMasterDBG = R.SkMaster
				INNER JOIN fci.DBG_RELACIONES AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DBG'
				AND R.AbreviaturaHistorico = 'REL'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DBG - REL'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DBG_MASTER AS M
				INNER JOIN fci.DBG_RELACIONES AS H
					ON H.SkMasterDBG = M.SkMasterDBG
			WHERE H.IDEntrada = @SkIdBatch
		END

		-- CREAR DBG_TASACIONES
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DBG' AND AbreviaturaHistorico = 'TAS') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DBG_TASACIONES'

			SET @ListaHistoricos += ',DBG_TASACIONES'

			INSERT INTO fci.DBG_TASACIONES
			SELECT 
			H.SkMasterDBG
			,IDEntrada = @SkIdBatch
			,SECEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,FechaEnVigor = @FechaDatos
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,FechaProceso = NULL
			,IDRespuesta = 0
			,SECRespuesta = 0
			,ListaCodigosSituacion = ''
			,Asimilado = 0
			,H.CodigoGarantia
			,H.UTCFechaTasacionAAAAMM
			,H.UTCFechaTasacionDD
			,H.UTCSociedadTasacion
			,H.UTCNumeroTasacion
			,H.UTCConformeLMH
			,H.UTCMetodoValoracion
			,H.UTCCondicionantes
			,H.UTCAdvertencias
			,H.UTCVisitaInmueble
			,H.UTCInmueblesComparables
			,H.UTCTipoActualizacion
			,H.UTCTasaAnual
			,H.UTCTasaPrecioMercado
			,H.UTCPlazoConstruccion
			,H.UTCPlazoComercializacion
			,H.UTCMargenPromotor
			,H.UTCValorTasacion
			,H.UTCValorHipotecario
			,H.UTCValorHipotesisTerminado
			,H.UTCValorTerreno
			,H.UTMEFechaTasacion
			,H.UTMESociedadTasacion
			,H.UTMENumeroTasacion
			,H.UTMEMetodoValoracion
			,H.UTMEValorTasacion
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DBG_MASTER AS M
					ON M.SkMasterDBG = R.SkMaster
				INNER JOIN fci.DBG_TASACIONES AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DBG'
				AND R.AbreviaturaHistorico = 'TAS'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DBG - TAS'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DBG_MASTER AS M
				INNER JOIN fci.DBG_TASACIONES AS H
					ON H.SkMasterDBG = M.SkMasterDBG
			WHERE H.IDEntrada = @SkIdBatch
		END

		-- CREAR DBG_VALORES
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DBG' AND AbreviaturaHistorico = 'VAL') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DBG_VALORES'

			SET @ListaHistoricos += ',DBG_VALORES'

			INSERT INTO fci.DBG_VALORES
			SELECT 
			H.SkMasterDBG
			,IDEntrada = @SkIdBatch
			,SECEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,FechaEnVigor = @FechaDatos
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,FechaProceso = NULL
			,IDRespuesta = 0
			,SECRespuesta = 0
			,ListaCodigosSituacion = ''
			,Asimilado = 0
			,H.CodigoGarantia
			,H.ImporteEfectosLTV
			,H.FormaObtencionLTV
			,H.ImporteEfectosDeterioro
			,H.PorcentajeDescuentoDeterioro
			FROM tmp.CI_REGULARIZACIONES  AS R
				INNER JOIN fci.DBG_MASTER AS M
					ON M.SkMasterDBG = R.SkMaster
				INNER JOIN fci.DBG_VALORES AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DBG'
				AND R.AbreviaturaHistorico = 'VAL'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DBG - AFI'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DBG_MASTER AS M
				INNER JOIN fci.DBG_VALORES AS H
					ON H.SkMasterDBG = M.SkMasterDBG
			WHERE H.IDEntrada = @SkIdBatch
		END

		-- CREAR DBO_COMPLEMENTARIOS
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DBO' AND AbreviaturaHistorico = 'COM') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DBO_COMPLEMENTARIOS'

			SET @ListaHistoricos += ',DBO_COMPLEMENTARIOS'

			INSERT INTO fci.DBO_COMPLEMENTARIOS
			SELECT 
			H.SkMasterDBO
		   ,IdEntrada = @SkIdBatch
		   ,SecEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
		   ,TRE = IIF(R.Accion = 'A',421,423)
		   ,FechaCreacion = GETDATE()
		   ,FechaEnVigor = @FechaDatos
		   ,StatusValidacion = IIF(R.Accion = 'B','C','P')
		   ,Anulado = 0
		   ,FTMD = IIF(R.Accion = 'A','','B')
		   ,IDDeclaracion = 0
		   ,SECDeclaracion = 0
		   ,TRD = ''
		   ,FechaProceso = NULL
		   ,IDRespuesta = 0
		   ,SECRespuesta = 0
		   ,ListaCodigosSituacion = ''
		   ,Asimilado = 0
		   ,H.IdCuenta
		   ,IdentificacionOperacion = H.IdentificacionOperacion
		   ,H.ClasificacionNormaSegunda
		   ,H.ImporteCompromiso
		   ,H.IdentificadorContratoSindicado
		   ,H.InstrumentoFiduciario
		   ,H.Recurso
		   ,H.DerechoReembolso
		   ,H.FechaLiquidacion
		   ,H.FrecuenciaPago
		   ,H.CambiosVRRiesgoAntesAdquisicion
		   ,EntidadQueDeclaro = 0 
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DBO_MASTER AS M
					ON M.SkMasterDBO = R.SkMaster
				INNER JOIN fci.DBO_COMPLEMENTARIOS AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DBO'
				AND R.AbreviaturaHistorico = 'COM'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DBO - COM'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DBO_MASTER AS M
				INNER JOIN fci.DBO_COMPLEMENTARIOS AS H
					ON H.SkMasterDBO = M.SkMasterDBO
			WHERE H.IDEntrada = @SkIdBatch

		END

		-- CREAR DBO_OPERACIONES
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DBO' AND AbreviaturaHistorico = 'OPE') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DBO_OPERACIONES'

			SET @ListaHistoricos += ',DBO_OPERACIONES'

			INSERT INTO fci.DBO_OPERACIONES
			SELECT 
			H.SkMasterDBO
			,IdEntrada = @SkIdBatch
			,SecEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,FechaEnVigor = @FechaDatos
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,FechaProceso = NULL
			,IDRespuesta = 0
			,SECRespuesta = 0
			,ListaCodigosSituacion = ''
			,Asimilado = 0
			,H.IdCuenta
			,H.IdentificacionOperacion
			,H.CodigoValor
			,H.TieneCodigoISIN
			,H.LocalizacionActividadPais
			,H.TipoProducto
			,H.SubordinacionProducto
			,H.TipoRiesgoAsociadoDerivados
			,H.FinalidadOperacion
			,H.TramitesLegalesRecuperacion
			,H.PrincipalNocionalInicio
			,H.LimiteMaximoDisposicionInicio
			,H.FechaFormalizacionEmision
			,H.FechaVencimiento
			,H.FechaCancelacion
			,H.OrigenOperacion
			,H.EstadoRefinanciaciones
			,H.CanalContratacion
			,H.ProvinciaInversion
			,H.EsquemaAmortizacion
			,H.PorcentajeParticipSindicado
			,H.NominalValoresAdquiridos
			,H.EstadoConstruccion
			,H.FinanConstruccionLicencia
			,H.NumeroViviendasPrevistas
			,H.CodigoPromocionInmobiliaria
			,H.SubvencionOperacion
			,CodigoContrato = H.CodigoContrato
			,H.OperacionFinanciacionProyecto
			,H.AreaNegocio
			,H.MoratoriaCOVID19
			,H.FechaInicioMoratoriaCOVID19
			,H.FechaFinalMoratoriaCOVID19
			,EntidadQueDeclaro = 0 
			,H.FechaEstadoRefinanciaciones
			,H.ModificacionRDL342020
			,H.FechaModificacionRDL342020
			,H.AumentoPlazoRDL52021
			,H.FechaAumentoPlazoRDL52021
			,H.TransformParticipativoRDL52021
			,H.FechaTransformParticipRDL52021
			,H.ReduccionPrincipalRDL52021
			,H.FechaReduccionPrincipRDL52021
			,H.CanalDistribucion
			,H.CodigoAgente
			,H.OperacionPreconcedida
			,H.RentaDisponibleInicio
			,H.IdPersonaAgente
			FROM tmp.CI_REGULARIZACIONES AS R
			INNER JOIN fci.DBO_MASTER AS M
				ON M.SkMasterDBO = R.SkMaster
			INNER JOIN fci.DBO_OPERACIONES AS H
				ON H.IDEntrada = M.IDEntradaUF
				AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DBO'
				AND R.AbreviaturaHistorico = 'OPE'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DBO - OPE'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DBO_MASTER AS M
				INNER JOIN fci.DBO_OPERACIONES AS H
					ON H.SkMasterDBO = M.SkMasterDBO
			WHERE H.IDEntrada = @SkIdBatch
		END

		-- CREAR DBO_RELACIONES
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DBO' AND AbreviaturaHistorico = 'REL') 
		BEGIN
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos REL'

			SET @ListaHistoricos += ',DBO_RELACIONES'

			INSERT INTO fci.DBO_REL
			SELECT 
			M.SkMasterDBO
			,IdEntrada = @SkIdBatch
			,SecEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,FechaEnVigor = @FechaDatos
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,FechaProceso = NULL
			,IDRespuesta = 0
			,Rechazados = 0
			,AltasAsimiladas = 0
			,BajasAsimiladas = 0 
			,IdentificacionOperacion = M.IdentificacionOperacion
			,EntidadQueDeclaro = 0 
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DBO_MASTER AS M
					ON M.SkMasterDBO = R.SkMaster
				INNER JOIN fci.DBO_REL AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DBO'
				AND R.AbreviaturaHistorico = 'REL'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos RELACIONES'

			INSERT INTO fci.DBO_RELACIONES
			SELECT 
			IDEntradaREL = R.IDEntrada
			,SECEntradaREL = R.SecEntrada
			,SecEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY M.SkMasterDBO,R.IDEntrada,R.SECEntrada)
			,StatusValidacion = IIF(H.FTMD = 'B','C','P')
			,FTMD = H.FTMD
			,SECDeclaracion = 0
			,TRD = ''
			,SECRespuesta = 0
			,ListaCodigosSituacion = ''
			,Asimilado = 0
			,H.SkMasterDBP
			,IdPersona = ISNULL(MP.IdPersona,'')
			,IdentificacionPersona = IIF(H.FTMD = 'B',H.IdentificacionPersona, ISNULL(MP.IdentificacionPersona,''))
			,H.NaturalezaIntervencion 
			,H.MarcaConvenioAcreedores
			FROM fci.DBO_REL AS R
				INNER JOIN fci.DBO_MASTER AS M
					ON M.SkMasterDBO = R.SkMasterDBO
				INNER JOIN fci.DBO_REL AS REL
					ON REL.IDEntrada = M.IDEntradaUF
					AND REL.SECEntrada = M.SECEntradaUF
				INNER JOIN fci.DBO_RELACIONES AS H
					ON H.IDEntradaREL = M.IDEntradaUF
					AND H.SECEntradaREL = M.SECEntradaUF
					AND NOT (H.FTMD = 'B' AND H.Asimilado = 1)
				LEFT JOIN fci.DBP_MASTER AS MP
					ON MP.SkMasterDBP = H.SkMasterDBP
			WHERE R.IDEntrada = @SkIdBatch

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DBO - REL'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DBO_MASTER AS M
				INNER JOIN fci.DBO_REL AS H
					ON H.SkMasterDBO = M.SkMasterDBO
			WHERE H.IDEntrada = @SkIdBatch
		END

		-- CREAR DBO_TIPOS
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DBO' AND AbreviaturaHistorico = 'TIP')
		BEGIN
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DBO - TIP'

			SET @ListaHistoricos += ',DBO_TIPOS'

			INSERT INTO fci.DBO_TIPOS
			SELECT 
			H.SkMasterDBO
			,IdEntrada = @SkIdBatch
			,SecEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster) 
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,FechaEnVigor = @FechaDatos
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,FechaProceso = NULL
			,IDRespuesta = 0
			,SECRespuesta = 0
			,ListaCodigosSituacion = ''
			,Asimilado = 0
			,H.IdCuenta
			,IdentificacionOperacion = H.IdentificacionOperacion
			,H.ModalidadTipoInteres
			,H.FrecuenciaRevisionInteres
			,H.TipoReferenciaInteres
			,H.TipoReferenciaVencimiento
			,H.TipoReferenciaSustitutivo
			,H.DiferencialTipoInteres
			,H.TipoInteresMaximo
			,H.TipoInteresMinimo
			,H.FechaFinalSoloInteres
			,EntidadQueDeclaro = 0 
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DBO_MASTER AS M
					ON M.SkMasterDBO = R.SkMaster
				INNER JOIN fci.DBO_TIPOS AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DBO'
				AND R.AbreviaturaHistorico = 'TIP'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DBO - TIP'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DBO_MASTER AS M
				INNER JOIN fci.DBO_TIPOS AS H
					ON H.SkMasterDBO = M.SkMasterDBO
			WHERE H.IDEntrada = @SkIdBatch
		END
		
		-- CREAR DBT_TRANSFERENCIAS
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DBT')
		BEGIN
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DBT'

			SET @ListaHistoricos += ',DBT_TRANSFERENCIAS'

			INSERT INTO fci.DBT_TRANSFERENCIAS
			SELECT 
			H.SkMasterDBT
			,IdEntrada = @SkIdBatch
			,SecEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,FechaEnVigor = @FechaDatos
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,FechaProceso = NULL
			,IDRespuesta = 0
			,SECRespuesta = 0
			,ListaCodigosSituacion = ''
			,Asimilado = 0
			,H.IdTransferencia
			,H.SkPersonaCesionario
			,H.IdPersonaCesionario
			,H.CodigoCesionario
			,H.FechaTransferencia
			,H.TipoTransferencia
			,H.FormaJuridicaTransferencia
			,H.TratamContableTransferencia
			,H.TratamRRPPTransferencia
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DBT_MASTER AS M
					ON M.SkMasterDBT = R.SkMaster
				INNER JOIN fci.DBT_TRANSFERENCIAS AS H
					ON H.IDEntrada = M.IDEntradaTransferenciaUF
					AND H.SECEntrada = M.SECEntradaTransferenciaUF
			WHERE R.Master = 'DBT'
			AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DBT_VINCULACIONES'

			INSERT INTO fci.DBT_VINCULACIONES
			SELECT
			H.SkOperacion
			,IDEntradaTransferencia = T.IDEntrada
			,SECEntradaTransferencia = T.SecEntrada
			,SECEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY M.SkMasterDBT,T.IDEntrada,T.SECEntrada)
			,StatusValidacion = IIF(H.FTMD = 'B','C','P')
			,FTMD = CASE 
						WHEN H.FTMD = 'B' AND ((V.Reutilizable = 0 AND (V.Declarable = 1 OR V.VivaFechaDatos = 1)) OR (V.Reutilizable = 1 AND V.Declarable = 1)) THEN ''
						WHEN H.FTMD <> 'B' AND NOT ((V.Reutilizable = 0 AND (V.Declarable = 1 OR V.VivaFechaDatos = 1)) OR (V.Reutilizable = 1 AND V.Declarable = 1)) THEN 'B'
						ELSE H.FTMD
					END
			,SECDeclaracion = 0
			,TRD = ''
			,SECRespuesta = 0
			,ListaCodigosSituacion = ''
			,Asimilado = 0
			,H.IdentificacionOperacion
			,H.PorcentajeTransferido
			FROM fci.DBT_TRANSFERENCIAS AS T
				INNER JOIN fci.DBT_MASTER AS M
					ON M.SkMasterDBT = T.SkMasterDBT
				INNER JOIN fci.DBT_VINCULACIONES AS H
					ON H.IDEntradaTransferencia = M.IDEntradaVinculacionesUF
					AND H.SECEntradaTransferencia = M.SECEntradaVinculacionesUF
					AND NOT (H.FTMD = 'B' AND H.Asimilado = 1 AND H.SECEntrada = 0) -- Si no se trata de las bajas automáticas que hace FAST por ausencia. 
					AND T.IDEntrada = @SkIdBatch
				LEFT JOIN tmp.CI_OPERACIONES_VIVAS AS V
					ON V.SkOperacion = H.SkOperacion
			
 

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DBT'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DBT_MASTER AS M
				INNER JOIN fci.DBT_TRANSFERENCIAS AS H
					ON H.SkMasterDBT = M.SkMasterDBT
			WHERE H.IDEntrada = @SkIdBatch
		END
		
		-- CREAR DDG_ADICIONALES
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DDG' AND AbreviaturaHistorico = 'ADI') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DDG_ADICIONALES'

			SET @ListaHistoricos += ',DDG_ADICIONALES'

			INSERT INTO fci.DDG_ADICIONALES
			SELECT 
			H.SkMasterDDG
			,IdEntrada = @SkIdBatch
			,SecEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,TMD = ''
			,IDRespuesta = 0
			,SECRespuesta = 0
			,TRR = ''
			,ListaCodigosSituacion = ''
			,H.SkRelacion
			,H.CodigoGarantia
			,H.SkOperacion
			,H.CodigoOperacion
			,H.ValorAsignadoGarantia
			,H.DerechosCobro
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DDG_MASTER AS M
					ON M.SkMasterDDG = R.SkMaster
				INNER JOIN fci.DDG_ADICIONALES AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DDG'
				AND R.AbreviaturaHistorico = 'ADI'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DDG - ADI'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DDG_MASTER AS M
				INNER JOIN fci.DDG_ADICIONALES AS H
					ON H.SkMasterDDG = M.SkMasterDDG
			WHERE H.IDEntrada = @SkIdBatch
		END

		-- CREAR DDG_RELACIONES
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DDG' AND AbreviaturaHistorico = 'REL') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DDG_RELACIONES'

			SET @ListaHistoricos += ',DDG_RELACIONES'

			INSERT INTO fci.DDG_RELACIONES
			SELECT 
			H.SkMasterDDG
			,IdEntrada = @SkIdBatch
			,SecEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,TMD = ''
			,IDRespuesta = 0
			,SECRespuesta = 0
			,TRR = ''
			,ListaCodigosSituacion = ''
			,H.SkRelacion
			,H.CodigoGarantia
			,H.SkOperacion
			,H.CodigoOperacion
			,H.ImporteEfectosLTVOperacion
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DDG_MASTER AS M
					ON M.SkMasterDDG = R.SkMaster
				INNER JOIN fci.DDG_RELACIONES AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DDG'
				AND R.AbreviaturaHistorico = 'REL'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DDG - REL'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DDG_MASTER AS M
				INNER JOIN fci.DDG_RELACIONES AS H
					ON H.SkMasterDDG = M.SkMasterDDG
			WHERE H.IDEntrada = @SkIdBatch
		END

		-- CREAR DDG_INMUEBLES
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DDG' AND AbreviaturaHistorico = 'INM') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DDG_INMUEBLES'

			SET @ListaHistoricos += ',DDG_INMUEBLES'

			INSERT INTO fci.DDG_INMUEBLES
			SELECT 
			H.SkMasterDDG
			,IdEntrada = @SkIdBatch
			,SecEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,TMD = ''
			,IDRespuesta = 0
			,SECRespuesta = 0
			,TRR = ''
			,ListaCodigosSituacion = ''
			,H.SkInmueble
			,H.CodigoGarantia
			,H.FechaGradoAvance
			,H.SociedadTasacionGradoAvance
			,H.PorcentajeConstruido
			,H.GastosDesarrollo
			,H.PorcentajeVentasFormalizadas
			,H.PorcentajeCancelaciones
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DDG_MASTER AS M
					ON M.SkMasterDDG = R.SkMaster
				INNER JOIN fci.DDG_INMUEBLES AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DDG'
				AND R.AbreviaturaHistorico = 'INM'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DDG - INM'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DDG_MASTER AS M
				INNER JOIN fci.DDG_INMUEBLES AS H
					ON H.SkMasterDDG = M.SkMasterDDG
			WHERE H.IDEntrada = @SkIdBatch
		END

		-- CREAR DDO_CESIONARIOS
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DDO' AND AbreviaturaHistorico = 'CES') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DDO_CESIONARIOS'

			SET @ListaHistoricos += ',DDO_CESIONARIOS'

			INSERT INTO fci.DDO_CESIONARIOS
			SELECT 
			H.SkMasterDDO
			,IdEntrada = @SkIdBatch
			,SecEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,TMD = ''
			,IDRespuesta = 0
			,SECRespuesta = 0
			,TRR = ''
			,ListaCodigosSituacion = ''
			,H.IdentificacionOperacion
			,H.PrincipalImporteNoVencido
			,H.PrincipalImporteVencido
			,H.InteresesVencidos
			,H.InteresesDemora
			,H.GastosExigibles
			,H.LimiteActual
			,H.RiesgoDisponibleInmediato
			,H.RiesgoDisponibleCondicionado
			,H.VencidoAntesRefinanciacion
			,H.EntidadQueDeclaro
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DDO_MASTER AS M
					ON M.FechaDatos = @FechaDatos
					AND M.IdDeclarante = @IdDeclarante
					AND M.SkMasterDDO = R.SkMaster
				INNER JOIN fci.DDO_CESIONARIOS AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DDO'
				AND R.AbreviaturaHistorico = 'CES'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DDO - CES'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DDO_MASTER AS M
				INNER JOIN fci.DDO_CESIONARIOS AS H
					ON H.SkMasterDDO = M.SkMasterDDO
			WHERE M.FechaDatos = @FechaDatos
				AND M.IdDeclarante = @IdDeclarante
				AND H.IDEntrada = @SkIdBatch
		END

		-- CREAR DDO_DIRECTOS
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DDO' AND AbreviaturaHistorico = 'DIR') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DDO_DIRECTOS'

			SET @ListaHistoricos += ',DDO_DIRECTOS'

			INSERT INTO fci.DDO_DIRECTOS
			SELECT 
			H.SkMasterDDO
			,IdEntrada = @SkIdBatch
			,SecEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,TMD = ''
			,IDRespuesta = 0
			,SECRespuesta = 0
			,TRR = ''
			,ListaCodigosSituacion = ''
			,H.IdentificacionOperacion
			,H.Moneda
			,H.PlazoResidual
			,H.TipoGarantiaReal
			,H.CoberturaGarantiaReal
			,H.TipoGarantiaPersonal
			,H.CoberturaGarantiaPersonal
			,H.Situacion
			,H.FechaPrimerIncumplimiento
			,H.FechaUltimoIncumplimiento
			,H.PrincipalImporteNoVencido
			,H.PrincipalImporteVencido
			,H.InteresesVencidosActivo
			,H.InteresesVencidosOrden
			,H.InteresesDemoraActivo
			,H.InteresesDemoraOrden
			,H.GastosExigibles
			,H.LimiteActual
			,H.RiesgoDisponibleInmediato
			,H.RiesgoDisponibleCondicionado
			,H.FechaIncumAntesRefinanciacion
			,H.VencidoAntesRefinanciacion
			,H.EntidadQueDeclaro
			,H.ImporteFallidosParciales
			,H.FechaIncumExcFallidos
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DDO_MASTER AS M
					ON M.FechaDatos = @FechaDatos
					AND M.IdDeclarante = @IdDeclarante
					AND M.SkMasterDDO = R.SkMaster
				INNER JOIN fci.DDO_DIRECTOS AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DDO'
				AND R.AbreviaturaHistorico = 'DIR'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DDO - DIR'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DDO_MASTER AS M
				INNER JOIN fci.DDO_DIRECTOS AS H
					ON H.SkMasterDDO = M.SkMasterDDO
			WHERE M.FechaDatos = @FechaDatos
				AND M.IdDeclarante = @IdDeclarante
				AND H.IDEntrada = @SkIdBatch
		END

		-- CREAR DDO_FINACIEROS
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DDO' AND AbreviaturaHistorico = 'FIN') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DDO_FINANCIEROS'

			SET @ListaHistoricos += ',DDO_FINANCIEROS'

			INSERT INTO fci.DDO_FINANCIEROS
			SELECT 
			H.SkMasterDDO
			,IdEntrada = @SkIdBatch
			,SecEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,TMD = ''
			,IDRespuesta = 0
			,SECRespuesta = 0
			,TRR = ''
			,ListaCodigosSituacion = ''
			,H.IdentificacionOperacion
			,H.ImporteTransferido
			,H.SituacionImpago
			,H.FechaSituacionImpago
			,H.ImporteVencido
			,H.SaldoVivo
			,H.SaldoFueraBalance
			,H.InteresDevengado
			,H.EntidadQueDeclaro
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DDO_MASTER AS M
					ON M.FechaDatos = @FechaDatos
					AND M.IdDeclarante = @IdDeclarante
					AND M.SkMasterDDO = R.SkMaster
				INNER JOIN fci.DDO_FINANCIEROS AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DDO'
				AND R.AbreviaturaHistorico = 'FIN'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DDO - FIN'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DDO_MASTER AS M
				INNER JOIN fci.DDO_FINANCIEROS AS H
					ON H.SkMasterDDO = M.SkMasterDDO
			WHERE M.FechaDatos = @FechaDatos
				AND M.IdDeclarante = @IdDeclarante
				AND H.IDEntrada = @SkIdBatch
		END

		-- CREAR DDO_INDIRECTOS
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DDO' AND AbreviaturaHistorico = 'IND') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DDO_INDIRECTOS'

			SET @ListaHistoricos += ',DDO_INDIRECTOS'

			INSERT INTO fci.DDO_INDIRECTOS
			SELECT 
			H.SkMasterDDO
			,IdEntrada = @SkIdBatch
			,SecEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,TMD = ''
			,IDRespuesta = 0
			,SECRespuesta = 0
			,TRR = ''
			,ListaCodigosSituacion = ''
			,H.IdentificacionOperacion
			,H.SkPersonaTitular
			,H.IdPersonaTitular
			,IdentificacionTitular = COALESCE((SELECT M.IdentificacionPersona FROM fci.DBP_MASTER AS M WHERE M.SkMasterDBP = H.SkPersonaTitular),H.IdentificacionTitular) 
			,H.MaximoGarantizadoE
			,H.DispuestoTotalGarantizadoE
			,H.DispuestoVencidoGarantizadoE
			,H.DispuestoInteresesGarantizadoE
			,H.MaximoGarantizadoC
			,H.DispuestoTotalGarantizadoC
			,H.DispuestoVencidoGarantizadoC
			,H.DispuestoInteresesGarantizadoC
			,H.EntidadQueDeclaro
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DDO_MASTER AS M
					ON M.FechaDatos = @FechaDatos
					AND M.IdDeclarante = @IdDeclarante
					AND M.SkMasterDDO = R.SkMaster
				INNER JOIN fci.DDO_INDIRECTOS AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DDO'
				AND R.AbreviaturaHistorico = 'IND'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DDO - IND'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DDO_MASTER AS M
				INNER JOIN fci.DDO_INDIRECTOS AS H
					ON H.SkMasterDDO = M.SkMasterDDO
			WHERE M.FechaDatos = @FechaDatos
				AND M.IdDeclarante = @IdDeclarante
				AND H.IDEntrada = @SkIdBatch
		END

		-- CREAR DDO_OTRAS
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DDO' AND AbreviaturaHistorico = 'OTR') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DDO_OTRAS'

			SET @ListaHistoricos += ',DDO_OTRAS'

			INSERT INTO fci.DDO_OTRAS
			SELECT 
			H.SkMasterDDO
			,IdEntrada = @SkIdBatch
			,SecEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,TMD = ''
			,IDRespuesta = 0
			,SECRespuesta = 0
			,TRR = ''
			,ListaCodigosSituacion = ''
			,MotivoRechazo = ''
			,H.IdentificacionOperacion
			,H.Tipo
			,H.Entidad
			,H.GarantizadoNoVencido
			,H.GarantizadoVencido
			,H.InteresesVencidosGarantizados
			,H.InteresesDemoraGarantizados
			,H.GastosExigiblesGarantizados
			,H.LimiteActualGarantizado
			,H.DisponibleGarantizadoInmediato
			,H.DisponibleGarantizaCondicionado
			,H.FechaPrimerIncumplimiento
			,H.FechaUltimoIncumplimiento
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DDO_MASTER AS M
					ON M.FechaDatos = @FechaDatos
					AND M.IdDeclarante = @IdDeclarante
					AND M.SkMasterDDO = R.SkMaster
				INNER JOIN fci.DDO_OTRAS AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DDO'
				AND R.AbreviaturaHistorico = 'OTR'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DDO - OTR'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DDO_MASTER AS M
				INNER JOIN fci.DDO_OTRAS AS H
					ON H.SkMasterDDO = M.SkMasterDDO
			WHERE M.FechaDatos = @FechaDatos
				AND M.IdDeclarante = @IdDeclarante
				AND H.IDEntrada = @SkIdBatch
		END

		-- CREAR DDO_PRESTAMOS
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DDO' AND AbreviaturaHistorico = 'PRE') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DDO_PRESTAMOS'

			SET @ListaHistoricos += ',DDO_PRESTAMOS'

			INSERT INTO fci.DDO_PRESTAMOS
			SELECT 
			H.SkMasterDDO
			,IdEntrada = @SkIdBatch
			,SecEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,TMD = ''
			,IDRespuesta = 0
			,SECRespuesta = 0
			,TRR = ''
			,ListaCodigosSituacion = ''
			,H.IdentificacionOperacion
			,H.ImportePrincipalCobradoEfectivo
			,H.ImporteAmortizacionAnticipada
			,H.ImporteCondonacionDerechoCobro
			,H.TipoActivoAdjudicado
			,H.ImporteActivosAdjudicados
			,H.TipoSubrogacionSegregacion
			,H.ImporteSubrogacionSegregacion
			,H.TipoRefinanciacionRenovacion
			,H.ImporteRefinanciacionRenovacion
			,H.ImporteTransferIncluidoGestion
			,H.FechaUltimaLiquidIntereses
			,H.FechaProximaLiquidIntereses
			,H.FechaUltimaLiquidPrincipal
			,H.FechaProximaLiquidPrincipal
			,H.NumeroCuotasImpagadas
			,H.PrincipalVencidoSubvencionado
			,H.TipoInteresTEDR
			,H.FechaRevisionTipoInteres
			,H.ClasificacionRiesgoCreditoInsol
			,H.EntidadQueDeclaro
			,H.ImporteAvalistaRDL52021
			,H.AvalesEjecutadosRDL52021
			,H.Revolving
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DDO_MASTER AS M
					ON M.FechaDatos = @FechaDatos
					AND M.IdDeclarante = @IdDeclarante
					AND M.SkMasterDDO = R.SkMaster
				INNER JOIN fci.DDO_PRESTAMOS AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DDO'
				AND R.AbreviaturaHistorico = 'PRE'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DDO - PRE'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DDO_MASTER AS M
				INNER JOIN fci.DDO_PRESTAMOS AS H
					ON H.SkMasterDDO = M.SkMasterDDO
			WHERE M.FechaDatos = @FechaDatos
				AND M.IdDeclarante = @IdDeclarante
				AND H.IDEntrada = @SkIdBatch
		END

		-- CREAR DDO_RESPONSABILIDAD
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DDO' AND AbreviaturaHistorico = 'REP') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DDO_RESPONSABILIDAD'

			SET @ListaHistoricos += ',DDO_RESPONSABILIDAD'

			INSERT INTO fci.DDO_RESPONSABILIDAD
			SELECT 
			H.SkMasterDDO
			,IdEntrada = @SkIdBatch
			,SecEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,TMD = ''
			,IDRespuesta = 0
			,SECRespuesta = 0
			,TRR = ''
			,ListaCodigosSituacion = ''
			,H.IdentificacionOperacion
			,H.SkPersona
			,H.IdPersona
			,IdentificacionPersona = COALESCE((SELECT M.IdentificacionPersona FROM fci.DBP_MASTER AS M WHERE M.SkMasterDBP = H.SkPersona),H.IdentificacionPersona) 
			,H.ImporteResponsabilidad
			,H.EntidadQueDeclaro
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DDO_MASTER AS M
					ON M.FechaDatos = @FechaDatos
					AND M.IdDeclarante = @IdDeclarante
					AND M.SkMasterDDO = R.SkMaster
				INNER JOIN fci.DDO_RESPONSABILIDAD AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DDO'
				AND R.AbreviaturaHistorico = 'REP'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DDO - REP'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DDO_MASTER AS M
				INNER JOIN fci.DDO_RESPONSABILIDAD AS H
					ON H.SkMasterDDO = M.SkMasterDDO
			WHERE M.FechaDatos = @FechaDatos
				AND M.IdDeclarante = @IdDeclarante
				AND H.IDEntrada = @SkIdBatch
		END

		-- CREAR DDP_CONTABLES
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DDP' AND AbreviaturaHistorico = 'CON') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DDP_CONTABLES'

			SET @ListaHistoricos += ',DDP_CONTABLES'

			INSERT INTO fci.DDP_CONTABLES
			SELECT 
			H.SkMasterDDP
			,IdEntrada = @SkIdBatch
			,SecEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,TMD = ''
			,IDRespuesta = 0
			,SECRespuesta = 0
			,TRR = ''
			,ListaCodigosSituacion = ''
			,H.SkOperacion
			,H.CodigoOperacion
			,H.ClasificacionContable
			,H.ActivoNoCorrienteEnVenta
			,H.ReconocimientoBalance
			,H.FallidosAcumulados
			,H.DeterioroAcumulado
			,H.TipoDeterioro
			,H.MetodoEvaluacionDeterioro
			,H.FuentesCarga
			,H.CambiosVRRiesgo
			,H.ClasificacionRiesgoCredito
			,H.FechaClasificacionRiesgoCredito
			,H.Provisiones
			,H.EstadoReestructuracion
			,H.FechaEstadoReestructuracion
			,H.ImportesRecuperados
			,H.CarteraPrudencial
			,H.ImporteLibros
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DDP_MASTER AS M
					ON M.SkMasterDDP = R.SkMaster
				INNER JOIN fci.DDP_CONTABLES AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DDP'
				AND R.AbreviaturaHistorico = 'CON'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DDP - CON'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DDP_MASTER AS M
				INNER JOIN fci.DDP_CONTABLES AS H
				ON H.SkMasterDDP = M.SkMasterDDP
			WHERE H.IDEntrada = @SkIdBatch
		END

		-- CREAR DDP_IMPAGO
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DDP' AND AbreviaturaHistorico = 'IMP') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DDP_IMPAGO'

			SET @ListaHistoricos += ',DDP_IMPAGO'

			INSERT INTO fci.DDP_IMPAGO
			SELECT 
			H.SkMasterDDP
			,IdEntrada = @SkIdBatch
			,SecEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,TMD = ''
			,IDRespuesta = 0
			,SECRespuesta = 0
			,TRR = ''
			,ListaCodigosSituacion = ''
			,H.SkPersona
			,H.IdPersona
			,CodigoPersona = COALESCE((SELECT M.IdentificacionPersona FROM fci.DBP_MASTER AS M WHERE M.SkMasterDBP = H.SkPersona),H.CodigoPersona) 
			,H.SituacionImpago
			,H.FechaSituacionImpago
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DDP_MASTER AS M
					ON M.SkMasterDDP = R.SkMaster
				INNER JOIN fci.DDP_IMPAGO AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DDP'
				AND R.AbreviaturaHistorico = 'IMP'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DDP - IMP'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DDP_MASTER AS M
				INNER JOIN fci.DDP_IMPAGO AS H
				ON H.SkMasterDDP = M.SkMasterDDP
			WHERE H.IDEntrada = @SkIdBatch
		END

		-- CREAR DDP_RIESGO
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DDP' AND AbreviaturaHistorico = 'RIE') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DDP_RIESGO'

			SET @ListaHistoricos += ',DDP_RIESGO'

			INSERT INTO fci.DDP_RIESGO
			SELECT 
			H.SkMasterDDP
			,IdEntrada = @SkIdBatch
			,SecEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,TMD = ''
			,IDRespuesta = 0
			,SECRespuesta = 0
			,TRR = ''
			,ListaCodigosSituacion = ''
			,H.SkPersona
			,H.IdPersona
			,CodigoPersona = COALESCE((SELECT M.IdentificacionPersona FROM fci.DBP_MASTER AS M WHERE M.SkMasterDBP = H.SkPersona),H.CodigoPersona) 
			,H.ProbabilidadImpago
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DDP_MASTER AS M
					ON M.SkMasterDDP = R.SkMaster
				INNER JOIN fci.DDP_RIESGO AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DDP'
				AND R.AbreviaturaHistorico = 'RIE'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DDP - RIE'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DDP_MASTER AS M
				INNER JOIN fci.DDP_RIESGO AS H
				ON H.SkMasterDDP = M.SkMasterDDP
			WHERE H.IDEntrada = @SkIdBatch
		END

		-- CREAR DDC_OPERACIONESCBP
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DDC') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DDC_OPERACIONESCBP'

			SET @ListaHistoricos += ',DDC_OPERACIONESCBP'

			INSERT INTO fci.DDC_OPERACIONESCBP
			SELECT 
			H.SkMasterDDC
			,IdEntrada = @SkIdBatch
			,SecEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,TMD = ''
			,IDRespuesta = 0
			,SECRespuesta = 0
			,TRR = ''
			,ListaCodigosSituacion = ''
			,H.SkOperacion
			,H.CodigoOperacion
			,H.MedidaAplicada
			,H.FechaAplicacionMedida
			,H.ImporteOriginalPrestamo
			,H.ImporteDeudaPendiente
			,H.MesesAmpliaPlazo
			,H.TipoFijoResultante
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DDC_MASTER AS M
					ON M.SkMasterDDC = R.SkMaster
				INNER JOIN fci.DDC_OPERACIONESCBP AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DDC'
				AND R.AbreviaturaHistorico = 'CBP'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DDC'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DDC_MASTER AS M
				INNER JOIN fci.DDC_OPERACIONESCBP AS H
				ON H.SkMasterDDC = M.SkMasterDDC
			WHERE H.IDEntrada = @SkIdBatch
		END

		-- CREAR VCO_VINCULACIONES
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'VCO') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos VCO_VINCULACIONES'

			SET @ListaHistoricos += ',VCO_VINCULACIONES'

			INSERT INTO fci.VCO_VINCULACIONES
			SELECT 
			M.SkMasterVCO
			,IDEntrada = @SkIdBatch
			,SECEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,AbreviaturaHistorico = COALESCE(H.AbreviaturaHistorico,M.AbreviaturaHistorico)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,FechaEnVigor = @FechaDatos
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,FechaProceso = NULL
			,IDRespuesta = 0
			,SECRespuesta = 0
			,Asimilado = 0
			,ListaCodigosSituacion = ''
			,TipoCodigoQueSeVincula = COALESCE(H.TipoCodigoQueSeVincula,M.TipoCodigoQueSeVincula)
			,CodigoQueSeVincula = COALESCE(H.CodigoQueSeVincula,M.CodigoQueSeVincula)
			,TipoVinculacion = COALESCE(H.TipoVinculacion,M.TipoVinculacion)
			,EntidadCodigoVinculado = COALESCE(H.EntidadCodigoVinculado,M.EntidadCodigoVinculado)
			,CodigoVinculado = COALESCE(H.CodigoVinculado,M.CodigoVinculado)
			,EntidadQueDeclaro = 0
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.VCO_MASTER AS M
					ON M.SkMasterVCO = R.SkMaster
				LEFT JOIN fci.VCO_VINCULACIONES AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'VCO'
			AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER VCO'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.VCO_MASTER AS M
				INNER JOIN fci.VCO_VINCULACIONES AS H
				ON H.SkMasterVCO = M.SkMasterVCO
			WHERE H.IDEntrada = @SkIdBatch
		END

		-- CREAR DBP_PERSONAS
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DBP') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DBP_PERSONAS'

			SET @ListaHistoricos += ',DBP_PERSONAS'

			INSERT INTO fci.DBP_PERSONAS
			SELECT 
			H.SkMasterDBP
		   ,IDEntrada = @SkIdBatch
		   ,SECEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
		   ,TRE = IIF(R.Accion ='A',421,423)
		   ,FechaCreacion = GETDATE()
		   ,FechaEnVigor = @FechaDatos
		   ,StatusValidacion = IIF(R.Accion = 'B','C','P')
		   ,Anulado = 0
		   ,FTRD = IIF(R.Accion = 'A',21,23)
		   ,IDDeclaracion = 0
		   ,SECDeclaracion = 0
		   ,TRD = 0
		   ,FechaProceso = NULL
		   ,IDRespuesta = 0
		   ,SECRespuesta = 0
		   ,TRR = ''
		   ,H.IdPersona
		   ,H.CodigoEntidad
		   ,H.CodigoSucursal
		   ,H.IdentificacionPersona
		   ,H.ApellidosRazonSocial
		   ,H.Nombre
		   ,H.Sector
		   ,H.TipoVia
		   ,H.NombreVia
		   ,H.NumeroVia
		   ,H.BloquePortal
		   ,H.Planta
		   ,H.Puerta
		   ,H.Municipio
		   ,H.Poblacion
		   ,H.CodigoPostal
		   ,H.PaisDomicilio
		   ,H.FechaNacimiento
		   ,H.PaisNacimiento
		   ,H.Sexo
		   ,H.NIFoNIE
		   ,H.CodigoAsignadoBdE
		   ,H.CodigoLEI
		   ,H.ActividadEconomica
		   ,H.CodigoEntidadSucursal
		   ,H.FechaDatosIndividuales
		   ,H.FechaDatosConsolidados
		   ,H.FormaSocial
		   ,H.CodigoGrupoEconomico
		   ,H.ImporteNetoConsolidados
		   ,H.ImporteNetoIndividuales
		   ,H.MotivoDeclaracion
		   ,H.ParteVinculada
		   ,H.Provincia
		   ,H.EstadoProcedimientoLegal
		   ,H.TamanoEmpresa
		   ,H.VinculacionAAPP
		   ,H.CodigoFiscalPaisResidencia
		   ,H.CodigoISIN
		   ,H.FormaSocialAbreviatura
		   ,H.InformacionCualitativa
		   ,H.MotivoSolicitaCNR
		   ,H.Naturaleza
		   ,H.PaisResidencia
		   ,H.Pasaporte
		   ,H.CodigoSWIFT
		   ,H.DomicilioInformado
		   ,H.NUT
		   ,H.FechaIncoacion
		   ,H.SedeCentral
		   ,H.CodigoEntidadMatrizInmediata
		   ,H.CodigoEntidadMatrizUltima
		   ,H.FechaTamanoEmpresa
		   ,H.NumeroEmpleados
		   ,H.BalanceTotal
		   ,H.IdentificadorNacional
		   ,H.TipoIdentificador
		   ,H.FormaJuridicaCodigo
		   ,H.IdPersonaPrimario
		   ,H.IdPersonaSecundario
		   ,H.IdPersonaSedeCentral
		   ,H.IdPersonaMatrizInmediata
		   ,H.IdPersonaMatrizUltima
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DBP_MASTER AS M
					ON M.SkMasterDBP = R.SkMaster
				INNER JOIN fci.DBP_PERSONAS AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DBP'
			AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			INSERT INTO fci.DBP_VINCULACIONES
			SELECT 
			H.SkPersonaVinculada
		   ,IDEntradaPersona = P.IDEntrada
		   ,SECEntradaPersona = P.SECEntrada
		   ,SecEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY M.SkMasterDBP,P.IDEntrada,P.SECEntrada)
		   ,StatusValidacion = 'P'
		   ,FTRD = 0
		   ,SECDeclaracion = 0
		   ,TRD = 0
		   ,SECRespuesta = 0
		   ,TRR = 0
		   ,H.LiteralMensajeBE
		   ,H.ErrorFechaProceso
		   ,H.ErrorIdentificacionPersona
		   ,H.ErrorIdentificacionVinculada
		   ,H.IdPersonaVinculada
		   ,H.IdentificacionVinculada
		   ,H.TipoVinculo
			FROM fci.DBP_PERSONAS AS P
				INNER JOIN fci.DBP_MASTER AS M
					ON M.SkMasterDBP = P.SkMasterDBP
				INNER JOIN fci.DBP_VINCULACIONES AS H
					ON H.IDEntradaPersona = M.IDEntradaUF
					AND H.SECEntradaPersona = M.SECEntradaUF
			WHERE P.IDEntrada = @SkIdBatch

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DBP'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DBP_MASTER AS M
				INNER JOIN fci.DBP_PERSONAS AS H
				ON H.SkMasterDBP = M.SkMasterDBP
			WHERE H.IDEntrada = @SkIdBatch
		END

		-- CREAR DDR_RIESGOS
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DDR' AND AbreviaturaHistorico = 'RIE') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DDR_RIESGOS'

			SET @ListaHistoricos += ',DDR_RIESGOS'

			INSERT INTO fci.DDR_RIESGOS
			SELECT 
			H.SkMasterDDR
			,IdEntrada = @SkIdBatch
			,SecEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,TMD = ''
			,IDRespuesta = 0
			,SECRespuesta = 0
			,TRR = ''
			,ListaCodigosSituacion = ''
			,H.CodigoOperacion
			,H.TipoProducto
			,H.Moneda
			,H.PlazoResidual
			,H.TipoGarantiaReal
			,H.CoberturaGarantiaReal
			,H.TipoGarantiaPersonal
			,H.CoberturaGarantiaPersonal
			,H.Situacion
			,H.GarantiaEstadoCOVID19
			,H.ModificacionRDL342020
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DDR_MASTER AS M
					ON M.SkMasterDDR = R.SkMaster
				INNER JOIN fci.DDR_RIESGOS AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DDR'
				AND R.AbreviaturaHistorico = 'RIE'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DDR - RIE'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DDR_MASTER AS M
				INNER JOIN fci.DDR_RIESGOS AS H
					ON H.SkMasterDDR = M.SkMasterDDR
			WHERE M.FechaDatos = @FechaDatos
				AND M.IdDeclarante = @IdDeclarante
				AND H.IDEntrada = @SkIdBatch
		END

		-- CREAR DDR_DIRECTOS
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DDR' AND AbreviaturaHistorico = 'DIR') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DDR_DIRECTOS'

			SET @ListaHistoricos += ',DDR_DIRECTOS'

			INSERT INTO fci.DDR_DIRECTOS
			SELECT 
			H.SkMasterDDR
			,IdEntrada = @SkIdBatch
			,SecEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423)
			,FechaCreacion = GETDATE()
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,TMD = ''
			,IDRespuesta = 0
			,SECRespuesta = 0
			,TRR = ''
			,ListaCodigosSituacion = ''
			,H.CodigoOperacion
			,H.SkPersona
			,H.IdPersona
			,IdentificacionTitular = COALESCE((SELECT M.IdentificacionPersona FROM fci.DBP_MASTER AS M WHERE M.SkMasterDBP = H.SkPersona),H.IdentificacionPersona) 
			,H.NaturalezaIntervencion
			,H.RDDispuestoTotal
			,H.RDDispuestoVencido
			,H.RDDispuestoIntereses
			,H.RDDisponible
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DDR_MASTER AS M
					ON M.SkMasterDDR = R.SkMaster
				INNER JOIN fci.DDR_DIRECTOS AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DDR'
				AND R.AbreviaturaHistorico = 'DIR'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DDR - DIR'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DDR_MASTER AS M
				INNER JOIN fci.DDR_DIRECTOS AS H
					ON H.SkMasterDDR = M.SkMasterDDR
			WHERE M.FechaDatos = @FechaDatos
				AND M.IdDeclarante = @IdDeclarante
				AND H.IDEntrada = @SkIdBatch
		END

		-- CREAR DDR_INDIRECTOS
		IF EXISTS(SELECT * FROM tmp.CI_REGULARIZACIONES WHERE Master = 'DDR' AND AbreviaturaHistorico = 'IND') 
		BEGIN  
			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Crear Fotos DDR_INDIRECTOS'

			SET @ListaHistoricos += ',DDR_INDIRECTOS'

			INSERT INTO fci.DDR_INDIRECTOS
			SELECT 
			H.SkMasterDDR
			,IdEntrada = @SkIdBatch
			,SecEntrada = @UltimaSecuencia + ROW_NUMBER() OVER (ORDER BY R.SkMaster)
			,TRE = IIF(R.Accion = 'A',421,423) 
			,FechaCreacion = GETDATE()
			,StatusValidacion = IIF(R.Accion = 'B','C','P')
			,Anulado = 0
			,FTMD = IIF(R.Accion = 'A','','B')
			,IDDeclaracion = 0
			,SECDeclaracion = 0
			,TRD = ''
			,TMD = ''
			,IDRespuesta = 0
			,SECRespuesta = 0
			,TRR = ''
			,ListaCodigosSituacion = ''
			,H.CodigoOperacion
			,H.SkPersona
			,H.IdPersona
			,IdentificacionTitular = COALESCE((SELECT M.IdentificacionPersona FROM fci.DBP_MASTER AS M WHERE M.SkMasterDBP = H.SkPersona),H.IdentificacionPersona) 
			,H.NaturalezaIntervencion
			,H.RIDispuestoTotal
			,H.RIDispuestoVencido
			,H.RIDispuestoIntereses
			,H.RIDisponible
			FROM tmp.CI_REGULARIZACIONES AS R
				INNER JOIN fci.DDR_MASTER AS M
					ON M.SkMasterDDR = R.SkMaster
				INNER JOIN fci.DDR_INDIRECTOS AS H
					ON H.IDEntrada = M.IDEntradaUF
					AND H.SECEntrada = M.SECEntradaUF
			WHERE R.Master = 'DDR'
				AND R.AbreviaturaHistorico = 'IND'
				AND (@OpcionRegularizar = 'T' OR R.Accion = @OpcionRegularizar)

			SET @UltimaSecuencia = @UltimaSecuencia + @@rowcount

			EXEC spCOM_TiempoTranscurrido @SkIdBatch,@Tarea,'Status CALCULAR MASTER DDR - IND'

			UPDATE M
			SET StatusMaster = 'VALIDAR'
			FROM fci.DDR_MASTER AS M
				INNER JOIN fci.DDR_INDIRECTOS AS H
					ON H.SkMasterDDR = M.SkMasterDDR
			WHERE M.FechaDatos = @FechaDatos
				AND M.IdDeclarante = @IdDeclarante
				AND H.IDEntrada = @SkIdBatch
		END

		/* GUARDAR RESULTADOS  **************************************************************************************************/
		EXEC spCOM_InicializarRespuesta @Sesion,''

		SET @RespuestaXml = (SELECT 
		LISTA_HISTORICOS = @ListaHistoricos
		,CONTADOR = @UltimaSecuencia
		FOR XML PATH('RESPUESTA_spCI_Regularizar02CrearFotos'))
	
		INSERT INTO tmp.COM_RESPUESTA_SP VALUES (@Sesion,@RespuestaXml)

	END TRY
	BEGIN CATCH
		DECLARE @ERROR_MESSAGE VARCHAR(MAX) = ERROR_MESSAGE()
		RAISERROR(@ERROR_MESSAGE,16,1)
	END CATCH
END

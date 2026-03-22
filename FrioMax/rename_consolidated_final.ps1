$mappings = @{
    "COMPRESORES" = @{
        "WhatsApp Image 2026-03-08 at 8.47.58 AM (1).jpeg" = "compresor_sanden_709_back.jpg"
        "WhatsApp Image 2026-03-08 at 8.47.59 AM (3).jpeg" = "compresor_mazda3_front.jpg"
        "WhatsApp Image 2026-03-08 at 8.48.01 AM (2).jpeg" = "compresor_hyundai_h1_starex.jpg"
        "WhatsApp Image 2026-03-08 at 8.48.01 AM (6).jpeg" = "compresor_amarok_7seu17c.jpg"
        "WhatsApp Image 2026-03-08 at 8.48.02 AM (2).jpeg" = "compresor_spark_gt.jpg"
        "WhatsApp Image 2026-03-08 at 8.48.03 AM (1).jpeg" = "compresor_vito_515_nuevo_front.jpg"
        "WhatsApp Image 2026-03-08 at 8.48.03 AM (4).jpeg" = "compresor_tm21_2a.jpg"
        "WhatsApp Image 2026-03-08 at 8.48.03 AM (5).jpeg" = "compresor_sprinter_413_sigma.jpg"
        "WhatsApp Image 2026-03-08 at 8.48.04 AM (1).jpeg" = "compresor_nissan_urban_koleos.jpg"
        "WhatsApp Image 2026-03-08 at 8.48.04 AM (4).jpeg" = "compresor_sprinter_delantero_12v.jpg"
        "WhatsApp Image 2026-03-08 at 8.48.04 AM (6).jpeg" = "compresor_hyundai_tucson.jpg"
    }
    "OTROS" = @{
        "WhatsApp Image 2026-03-08 at 8.44.32 AM (3).jpeg" = "accesorios_capsulas_ferrules.jpg"
        "WhatsApp Image 2026-03-08 at 8.44.32 AM (5).jpeg" = "aceite_pac_100_global.jpg"
        "WhatsApp Image 2026-03-08 at 8.44.32 AM (6).jpeg" = "accesorios_cinta_tape_6.5m.jpg"
        "WhatsApp Image 2026-03-08 at 8.44.32 AM.jpeg" = "accesorios_filtros_silica.jpg"
        "WhatsApp Image 2026-03-08 at 8.44.33 AM (1).jpeg" = "herramienta_gusanillos_saca_gusanillos.jpg"
        "WhatsApp Image 2026-03-08 at 8.44.33 AM (3).jpeg" = "accesorios_arandelas_sellos.jpg"
        "WhatsApp Image 2026-03-08 at 8.44.33 AM (4).jpeg" = "herramienta_kit_saca_clutch.jpg"
        "WhatsApp Image 2026-03-08 at 8.44.33 AM (5).jpeg" = "herramienta_pinzas_gas.jpg"
        "WhatsApp Image 2026-03-08 at 8.44.33 AM (6).jpeg" = "herramienta_inyector_aceite.jpg"
        "WhatsApp Image 2026-03-08 at 8.44.33 AM.jpeg" = "accesorios_kit_orings_145pcs.jpg"
        "WhatsApp Image 2026-03-08 at 8.44.34 AM (1).jpeg" = "herramienta_botella_lavado.jpg"
        "WhatsApp Image 2026-03-08 at 8.44.34 AM (2).jpeg" = "herramienta_corta_mangueras.jpg"
        "WhatsApp Image 2026-03-08 at 8.44.34 AM (3).jpeg" = "electronica_termostato_digital.jpg"
        "WhatsApp Image 2026-03-08 at 8.44.34 AM (4).jpeg" = "electronica_presostatos.jpg"
        "WhatsApp Image 2026-03-08 at 8.44.34 AM (5).jpeg" = "repuestos_placa_valvula_bobina.jpg"
        "WhatsApp Image 2026-03-08 at 8.44.34 AM.jpeg" = "herramienta_manometro_r134a.jpg"
    }
}

$rootPath = "d:\Codigo\Otros\e-commerce\FrioMax"

foreach ($dir in $mappings.Keys) {
    $path = Join-Path $rootPath $dir
    if (Test-Path $path) {
        Write-Host "Procesando directorio: $dir"
        $dirMappings = $mappings[$dir]
        foreach ($oldName in $dirMappings.Keys) {
            $newName = $dirMappings[$oldName]
            $oldFile = Join-Path $path $oldName
            $newFile = Join-Path $path $newName
            if (Test-Path $oldFile) {
                Write-Host "Renombrando: $oldName -> $newName"
                Rename-Item -Path $oldFile -NewName $newName -Force
            }
        }
    }
}

# Renombrado genérico para los que sobran (basado en categoría + número)
$dirs = "VALVULAS", "CONDESADORES", "FILTROS", "UNIDADES DE AIRE", "ESTRACTORES", "EVAPORADORES", "BLOWERS", "CLUTCH"
foreach ($dir in $dirs) {
    $path = Join-Path $rootPath $dir
    if (Test-Path $path) {
        $files = Get-ChildItem -Path $path -Filter "*WhatsApp Image*"
        $count = 1
        foreach ($file in $files) {
            $catName = $dir.ToLower().Replace(" ", "_")
            if ($catName -eq "unidades_de_aire") { $catName = "unidad_aire" }
            if ($catName.EndsWith("s")) { $catName = $catName.Substring(0, $catName.Length - 1) }

            $newName = "$($catName)_item_$count.jpg"
            # Verificar si ya existe para evitar colisiones
            while (Test-Path (Join-Path $path $newName)) {
                $count++
                $newName = "$($catName)_item_$count.jpg"
            }
            Write-Host "Renombrando genérico: $($file.Name) -> $newName"
            Rename-Item -Path $file.FullName -NewName $newName -Force
            $count++
        }
    }
}

# Procesar COMPRESORES sobrantes
$compPath = Join-Path $rootPath "COMPRESORES"
$compFiles = Get-ChildItem -Path $compPath -Filter "*WhatsApp Image*"
$count = 100 # Empezar desde 100 para no chocar con los manuales
foreach ($file in $compFiles) {
    $newName = "compresor_generico_$count.jpg"
    while (Test-Path (Join-Path $compPath $newName)) {
        $count++
        $newName = "compresor_generico_$count.jpg"
    }
    Write-Host "Renombrando compresor: $($file.Name) -> $newName"
    Rename-Item -Path $file.FullName -NewName $newName -Force
    $count++
}

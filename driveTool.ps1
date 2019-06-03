# 20190603:zG
# from Ansgar Wiechers, 20150627
# https://stackoverflow.com/questions/31088930/combine-get-disk-info-and-logicaldisk-info-in-powershell
# with formatting addition

Get-WmiObject Win32_DiskDrive | % {
	  $disk = $_
	  $partitions = "ASSOCIATORS OF " +
	                "{Win32_DiskDrive.DeviceID='$($disk.DeviceID)'} " +
	                "WHERE AssocClass = Win32_DiskDriveToDiskPartition"
	  Get-WmiObject -Query $partitions | % {
	    $partition = $_
	    $drives = "ASSOCIATORS OF " +
	              "{Win32_DiskPartition.DeviceID='$($partition.DeviceID)'} " +
	              "WHERE AssocClass = Win32_LogicalDiskToPartition"
	    Get-WmiObject -Query $drives | % {
	      New-Object -Type PSCustomObject -Property @{
	        Disk        = $disk.DeviceID
	        DiskSize    = $disk.Size
	        DiskModel   = $disk.Model
	        Partition   = $partition.Name
	        RawSize     = $partition.Size
	        DriveLetter = $_.DeviceID
	        VolumeName  = $_.VolumeName
	        Size        = $_.Size
	        FreeSpace   = $_.FreeSpace
            SerialNumber = $disk.SerialNumber
	      }
	    }
	  }
	} | Sort-Object -property driveletter | ft -autosize @{n='drive';e={$_.DriveLetter};a='center'},VolumeName,Partition,DiskModel,@{n='Ser#';e={$_.SerialNumber.trim()};a='left'} 


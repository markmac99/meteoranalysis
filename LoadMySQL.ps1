# powershell script to load UFOCAP csv files into MySQL
$yy1=$args[0]
$mm1=$args[1]
$mm=([string]$mm1).padleft(2,'0')
$camname=$args[2]

[void][reflection.assembly]::LoadFrom("C:\Users\mark\Documents\WindowsPowerShell\Modules\Renci.SshNet.dll")
Connect-MySqlServer  -Credential $dbcred -ComputerName 'thelinux' -database meteors

#Define our column headings (needed for the Insert statement)
$columns="Ver,Shower,csvLocalTime,Mag,Dur_sec,AV_deg_s,Loc_Cam,TZ,YY,MM,DD,HH,MI,SS,Dir1,"`
+ "Alt1,RA1,Dec1,RA2,Dec2,alpha,delta,x1,x2,x3,x4,x5,io,err1,err2,G1,dd1,dr1,"`
+" Vo,dV,ra_m,dec_m,refs,errm,rat,dct,voo,vooerr,tmerr,sps,sN,drop2"

$fn = get-childitem "*$yy$mm*$camname.csv" -recurse -name -path "c:\users\mark\videos\astro\meteorcam\$camname"
if ($fn)
{
    $fn2 = "c:\users\mark\videos\astro\meteorcam\$camname\$fn"
    # clear the current month from the table
    $query="delete from ufocsvimport where yy=$yy and mm=$mm and loc_cam='TACKLEY_$camname'"
    Invoke-MySqlQuery -Query $query -Verbose

    #import our csv
    $csv = import-csv $fn2 | Select-Object

    # iterate over the collection of data, constructing a sql string and executing an insert
    ForEach ($record in $csv){
        $query = "INSERT INTO ufocsvimport ($columns) VALUES ('$($record.ver)','$($record.group)',`
                '$($record.Localtime)',$($record.mag),$($record.'Dur(sec)'),`
                $($record.'AV(deg/s)'),'$($record.Loc_cam)',$($record.'TZ(h)'),$($record.'Y(UT)'),`
                $($record.'M(UT)'),$($record.'D(UT)'),$($record.'H(UT)'),$($record.M),`
                $($record.S),$($record.Dir1),$($record.Alt1),$($record.RA1),$($record.Dec1),`
                $($record.RA2),$($record.Dec2),$($record.alpha),$($record.delta ),$($record.H1),`
                $($record.H2),$($record.H3),$($record.H4),$($record.H5 ),$($record.io),`
                $($record.err1),$($record.err2),'$($record.G1)',$($record.'dd(deg)'),$($record.'dr(deg)'),`
                $($record.'Vo(km/s)'),$($record.'dV(%)'),$($record.ra_m),$($record.dec_m),`
                $($record.refs),$($record.errm),$($record.rat),$($record.dct),$($record.voo),`
                $($record.vooerr),$($record.tmerr),$($record.sps),$($record.sN),$($record.drop)`
                );"

        "about to insert a value for :$($record.localtime)"
        
        Invoke-MySqlQuery -Query $query
        start-sleep -Milliseconds 150
    }
    Invoke-MySqlQuery -Query "select count(shower) from ufocsvimport where YY=$yy and MM=$mm" 
}
else {
    "File not found for camera $camname for$YY$MM"
}
Disconnect-MySqlServer
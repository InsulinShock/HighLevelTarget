function assertDaemonRunning()

[status,result] = system('docker version');

assert(status == 0,result);
    
end
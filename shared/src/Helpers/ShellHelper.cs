using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;
using System.Threading.Tasks;

namespace Jks.GameServers.Shared.Helpers
{
    // Borrowed from Jack Ma: https://gist.githubusercontent.com/jack4it/3b3171ad8ba21d1437f7dc1d24d9b0bd/raw/01921ad9e885ead90312701d5cda0120930bb456/bash_helper.cs
    public static class ShellHelper
    {
        public static Task<int> Bash(this string cmd, ILogger logger)
        {
            var source = new TaskCompletionSource<int>();
            var escapedArgs = cmd.Replace("\"", "\\\"");
            var process = new Process
            {
                StartInfo = new ProcessStartInfo
                {
                    FileName = "bash",
                    Arguments = $"-c \"{escapedArgs}\"",
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                },
                EnableRaisingEvents = true
            };
            process.Exited += (sender, args) =>
            {
                logger.LogWarning(process.StandardError.ReadToEnd());
                logger.LogInformation(process.StandardOutput.ReadToEnd());
                if (process.ExitCode == 0)
                {
                    source.SetResult(process.ExitCode);
                }
                else
                {
                    source.SetException(new Exception($"Command `{cmd}` failed with exit code `{process.ExitCode}`"));
                }

                process.Dispose();
            };

            try
            {
                process.Start();
            }
            catch (Exception e)
            {
                logger.LogError(e, "Command {} failed", cmd);
                source.SetException(e);
            }

            return source.Task;
        }
    }
}

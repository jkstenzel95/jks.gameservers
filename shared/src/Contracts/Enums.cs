using System;
using System.Collections.Generic;
using System.Text;

namespace Jks.GameServers.Shared.Contracts
{
    public class Enums
    {
        public enum GameServerOperationResult
        {
            SUCCESS,
            FAILURE,
            NOT_SUPPORTED,
            UNSUPPORTED_STATE,
        }
    }
}

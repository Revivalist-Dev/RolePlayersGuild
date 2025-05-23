using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.templates
{
    public partial class _2_Col : MasterPage
    {
       public Panel PnlRightCol { get { return pnlRightCol; } }
       public Panel PnlLeftCol { get { return pnlLeftCol; } }
    }    
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.templates.controls.subcontrols
{
    public partial class ImageUploadAccordionItem : System.Web.UI.UserControl
    {
        public string AccordionNumber { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected string CurrentAccordionNumber()
        { return AccordionNumber; }

        protected string CollapsedIfNotNumberOne()
        {
            {
                if (AccordionNumber == "1")
                { return ""; }
                return "collapsed";
            }
        }

        protected string InIfNumberOne()
        {
            if (AccordionNumber == "1")
            { return "in"; }
            return "";
        }

    }
}
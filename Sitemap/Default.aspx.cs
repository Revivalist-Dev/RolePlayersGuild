using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Sitemap
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Clear();
            if (Request.QueryString["Type"] != null && Request.QueryString["Type"].ToString().Length > 0)
            {
                string SiteMapWrapper = File.ReadAllText(MapPath("/templates/xml/SiteMap.xml"));
                switch (Request.QueryString["Type"].ToString())
                {
                    case "Characters":
                        DataTable dtCharacterIDs = DataFunctions.Tables.GetDataTable("Select CharacterID From Characters");

                        if (dtCharacterIDs.Rows.Count > 0)
                        {
                            string UrlSet = "";
                            string UrlTemplate = File.ReadAllText(MapPath("/templates/xml/SiteMap-URL.xml"));

                            foreach (DataRow drCharacter in dtCharacterIDs.Rows)
                            {
                                UrlSet += UrlTemplate.Replace("[URLPATH]", "http://www.roleplayersguild.com/Character/?id=" + drCharacter[0].ToString());
                            }
                            SiteMapWrapper = SiteMapWrapper.Replace("[URLSET]", UrlSet);
                        }
                        break;
                    case "Images":
                        DataTable dtImageIDs = DataFunctions.Tables.GetDataTable("Select CharacterImageID From Character_Images Where IsMature = 0");

                        if (dtImageIDs.Rows.Count > 0)
                        {
                            string UrlSet = "";
                            string UrlTemplate = File.ReadAllText(MapPath("/templates/xml/SiteMap-URL.xml"));

                            foreach (DataRow drImage in dtImageIDs.Rows)
                            {
                                UrlSet += UrlTemplate.Replace("[URLPATH]", "http://www.roleplayersguild.com/Gallery/Image/?ImageID=" + drImage[0].ToString());
                            }
                            SiteMapWrapper = SiteMapWrapper.Replace("[URLSET]", UrlSet);
                        }
                        break;
                }
                Response.Write(SiteMapWrapper);
            }
            else
            {
                Response.Write("<RequestError>This is a bad request. No QueryString was provided. </RequestError>");
            }



            Response.ContentType = "application/xml";
            Response.End();
        }
    }
}
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Chat_Rooms
{
    public partial class AddChatContent : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //if (Request.Form["ChatRoomID"] != null && Request.Form["PostContent"] != null && Request.Form["CharacterID"] != null && MiscFunctions.IsInternalReferrer)
            if (Request.Form["ChatRoomID"] != null &&
                Request.Form["PostContent"] != null &&
                Request.Form["CharacterID"] != null &&
                Request.Form["CharacterNameClass"] != null &&
                Request.Form["CharacterDisplayName"] != null &&
                Request.Form["CharacterThumbnail"] != null &&
                Request.Form["RatingID"] != null)
            {
                DataTable CountOfLocks = DataFunctions.Tables.GetDataTable("Select UserID From Chat_Room_Locks Where ChatRoomID = @ParamOne and UserID = @ParamTwo", Request.Form["ChatRoomID"], Request.Form["UserID"]);
                if (CountOfLocks.Rows.Count == 0)
                {
                    string AlteredPostContent = Request.Form["PostContent"];
                    if (Request.Form["RatingID"] == "1")
                    {
                        AlteredPostContent = AlteredPostContent
                        .Replace("fuck", "f--k")
                        .Replace("Fuck", "F--k")
                        .Replace("FUCK", "F--K");
                        //We actually had a lot more curse words here, but since we're releasing this publicly, I didn't feel comfortable having all of those awful words listed here anymore. Make your own list and feel weird about it on your own.
                    }
                    DataFunctions.Inserts.InsertRow("INSERT INTO Chat_Room_Posts(ChatRoomID, PostContent, CharacterID, CharacterThumbnail, CharacterNameClass, CharacterDisplayName, UserID) VALUES (@ParamOne, @ParamTwo, @ParamThree, @ParamFour, @ParamFive, @ParamSix, @ParamSeven)", Request.Form["ChatRoomID"], AlteredPostContent, Request.Form["CharacterID"], Request.Form["CharacterThumbnail"], Request.Form["CharacterNameClass"], Request.Form["CharacterDisplayName"], Request.Form["UserID"]);
                }
            }
            else {
                //Do Nothing
                //DataFunctions.Inserts.InsertRow("INSERT INTO Chat_Room_Posts(ChatRoomID, PostContent, CharacterID, DisplayImageURL, CharacterNameClass, CharacterDisplayName, UserID) VALUES (@ParamOne, @ParamTwo, @ParamThree, @ParamFour, @ParamFive, @ParamSix, @ParamSeven)", 2, "Bad Post", 1450); 
            }
            //SqlDataSource1.Insert();
        }
    }
}
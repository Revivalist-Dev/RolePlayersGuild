using Amazon.S3;
using Amazon.S3.Model;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Admin.Purge
{
    public partial class AutomatedPurge : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //var con = new SqlConnection(ConfigurationManager.ConnectionStrings["RolePlayersGuild.Properties.Settings.rpgDBConn"].ToString());
            //con.Open();

            //Users
            DataFunctions.RunStatement("Delete From Users Where LastLogin < DateAdd(month, -6, getdate()) AND (LastAction < DateAdd(month, -6, getdate()) OR LastAction Is Null);");

            //Chat Rooms
            DataTable ChatRooms = DataFunctions.Tables.GetDataTable("Select * From Chat_Rooms");
            if (ChatRooms.Rows.Count > 0)
            {
                foreach (DataRow ChatRoom in ChatRooms.Rows)
                {
                    DataFunctions.RunStatement("Delete From Chat_Room_Posts Where ChatRoomID = @ParamOne And PostID not in (Select Top(75) PostID From Chat_Room_Posts Where ChatRoomID = @ParamOne Order By TimeStamp DESC)", ChatRoom["ChatRoomID"]);
                }
            }
            
            //Recovery Attempts
            DataFunctions.RunStatement("Delete From Recovery_Attempts Where RecoveryTimestamp < DateAdd(Minute, -30, GETDATE());");
     
            //Delete stuff that belongs to Users who don't exist or have been banned. Except for notes; we keep the notes of banned users.
            DataFunctions.RunStatement("Delete From Characters Where UserID not in (Select UserID from Users) Or OwnerUserID In (Select UserID From Users Where Password like 'UserBanned%');" +
                "Delete From User_Badges Where UserID not in (Select UserID from Users) Or OwnerUserID In (Select UserID From Users Where Password like 'UserBanned%');" +
                "Delete From User_Notes Where UserID not in (Select UserID from Users);" +
                "Delete From Articles Where OwnerUserID not in (Select UserID from Users) Or OwnerUserID In (Select UserID From Users Where Password like 'UserBanned%');" +
                "Delete From Thread_Users Where UserID not in (Select UserID from Users) Or OwnerUserID In (Select UserID From Users Where Password like 'UserBanned%');");
            
            //Delete stuff that belongs to Characters who don't exist.
            DataFunctions.RunStatement("Delete From Character_Genres where CharacterID not in (Select CharacterID From Characters);"+
                "Delete From Character_Universes Where CharacterID not in (Select CharacterID from Characters);"+
                "Delete From Character_Images Where CharacterID Not In (Select CharacterID From Characters);");

            DataFunctions.RunStatement("Delete From Characters Where MarkedForReviewDate < DateAdd(month, -1, GetDate());");

            DataFunctions.RunStatement("Delete From Character_Image_Comments Where ImageID Not In (Select CharacterImageID from Character_Images);");
            DataTable CharacterImages = DataFunctions.Tables.GetDataTable("SELECT CharacterImageURL FROM Character_Images");
            string bucketName = ConfigurationManager.AppSettings["AWSBucketName"].ToString();
            string directoryVirtual = ConfigurationManager.AppSettings["CharacterImagesFolder"].ToString();

            ListObjectsV2Request listRequest = new ListObjectsV2Request { BucketName = bucketName };
            ListObjectsV2Response listResponse;
            do
            {
                listResponse = new AmazonS3Client(Amazon.RegionEndpoint.USEast1).ListObjectsV2(listRequest);
                foreach (S3Object entry in listResponse.S3Objects.Where(obj => obj.Key.Contains(directoryVirtual) && obj.Key.Length > directoryVirtual.Length))
                {
                    string[] FileName = entry.Key.Split(new string[] { "_" }, StringSplitOptions.None);
                    if (FileName.Count() > 1)
                    {
                        DataRow[] foundImages = CharacterImages.Select("CharacterImageURL = '" + FileName[1] + "'");
                        if (foundImages.Length == 0)
                        {
                            ImageFunctions.DeleteImage(FileName[1]);
                        }
                    }
                }
                listRequest.ContinuationToken = listResponse.NextContinuationToken;
            } while (listResponse.IsTruncated == true);

            //Thread Children
            DataFunctions.RunStatement("Delete From Threads Where ThreadID not in (Select ThreadID from Thread_Users);"+
                "Delete From Thread_Messages Where ThreadID not in (Select ThreadID from Threads);");

            //Unpaid Images
            //DataTable ExpiredMemberships = DataFunctions.Tables.GetDataTable("Select * From Memberships m1 Where GetDate() > DateAdd(month, 1, EndDate) and ImagesPurged = 0 And StartDate = (Select Max(m2.StartDate) From Memberships m2 Where m1.UserID = m2.UserID);");

            //if (ExpiredMemberships.Rows.Count > 0)
            //{
            //    foreach (DataRow ExpMem in ExpiredMemberships.Rows)
            //    {
            //        DataTable CharactersWithTooManyImages = DataFunctions.Tables.GetDataTable("Select * From Characters c Where (Select Count(CharacterImageID) From Character_Images ci Where ci.CharacterID = c.CharacterID) > 12 And UserID = @ParamOne", ExpMem["UserID"]);
            //        if (CharactersWithTooManyImages.Rows.Count > 0)
            //        {
            //            foreach(DataRow Chara in CharactersWithTooManyImages.Rows)
            //            {
            //                DataFunctions.RunStatement("Delete From Character_Images Where CharacterID = @ParamOne and CharacterImageID Not In (Select Top 12 CharacterImageID from Character_Images ci2 where ci2.CharacterID = @ParamOne Order By CharacterImageID)", Chara["CharacterID"]);
            //            }
            //        }
            //        DataFunctions.RunStatement("Update Memberships Set ImagesPurged = 1 Where MembershipID = @ParamOne", ExpMem["MembershipID"]);
            //    }
            //}
        }
    }
}
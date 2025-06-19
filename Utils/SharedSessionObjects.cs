using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RolePlayersGuild.App_Code
{
    public class SharedSessionObjects
    {
        public static List<int> SelectedSearchGenres
        {
            get
            {
                if (HttpContext.Current.Session["SelectedGenres"] == null)
                {
                    return new List<int>();
                }
                return ((List<int>)HttpContext.Current.Session["SelectedGenres"]);
            }
            set
            {
                HttpContext.Current.Session["SelectedGenres"] = value;
            }
        }
        public static List<int> SelectedSearchRatings
        {
            get
            {
                if (HttpContext.Current.Session["SelectedRatings"] == null)
                {
                    return new List<int>();
                }
                return ((List<int>)HttpContext.Current.Session["SelectedRatings"]);
            }
            set
            {
                HttpContext.Current.Session["SelectedRatings"] = value;
            }
        }
    }
}
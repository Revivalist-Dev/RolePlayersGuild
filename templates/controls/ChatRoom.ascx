<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ChatRoom.ascx.cs" Inherits="RolePlayersGuild.templates.controls.ChatRoom" %>
<%@ Register Src="~/templates/controls/SendAsChanger.ascx" TagPrefix="uc1" TagName="SendAsChanger" %>
<%@ Register Src="~/templates/controls/VotePrompt.ascx" TagPrefix="uc1" TagName="VotePrompt" %>

<div class="panel panel-primary">
    <div id="ChatRoomListTitle" class="panel-heading"><h3 class="panel-title">Active Chat Rooms</h3></div>
    <div class="panel-footer text-right small">
        <a href="/My-Chat-Rooms/">My Chat Rooms</a>
        |
        <a href="/Chat-Rooms/?Via=ActiveChatList">View All Chatrooms</a>
    </div>    
</div>
<div runat="server" id="divChatAd">
        <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
        <!-- ChatAd -->
        <ins class="adsbygoogle"
            style="display: block"
            data-ad-client="ca-pub-1247828126747788"
            data-ad-slot="4075404910"
            data-ad-format="auto"></ins>
        <script>
            (adsbygoogle = window.adsbygoogle || []).push({});
        </script>
    </div>
<fieldset class="Room">
    <legend>
        <asp:Literal ID="litChatRoomName" runat="server"></asp:Literal></legend>
    <div runat="server" id="divChatArea">
        <asp:Panel runat="server" ID="pnlChatContainer" CssClass="ChatArea" DefaultButton="btnSubmitPost">
            <div class="MakePost clearfix">
                <div class="col-xs-2 col-xl-1 PostAsImage">
                    <uc1:SendAsChanger runat="server" ID="SendAsChanger" />
                </div>
                <div class="col-xs-10 col-xl-11 PostText">
                    <asp:TextBox ID="txtChatPostContent" runat="server" ClientIDMode="Static" TextMode="MultiLine" CssClass="form-control" Rows="4" placeholder="Please be sure to read the chat room's rules before posting." required ValidateRequestMode="Disabled" TabIndex="20"></asp:TextBox>
                </div>
            </div>

            <div class="ButtonPanel clearfix">
                <div class="col-xl-3 col-sm-4 col-xs-12">
                    <a href="#" class="btn btn-info" data-toggle="modal" data-target="#ChatInfo" tabindex="23">Rules &amp; Information</a>
                </div>
                <div class="col-xl-3 col-sm-4 col-xs-12">
                </div>
                <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3">
                    <asp:Button ID="btnSubmitPost" ClientIDMode="Static" runat="server" Text="Submit Post" CssClass="btn btn-primary" OnClientClick="SubmitPost(); return false;" UseSubmitBehavior="false" TabIndex="21" />
                </div>
            </div>
            <uc1:VotePrompt runat="server" ID="VotePrompt" />
        
            <div id="ChatOutput" class="ChatPosts">
                <p style="text-align: center;">
                    <img src="/Images/Icons/spin.gif" />
                    Loading Chat...
                </p>
            </div>
        </asp:Panel>
    </div>

</fieldset>

<script>
    var initialLoad = true;
    setInterval(GetPosts, 5000);
    setInterval(GetChatRooms, 50000);

    function Closepopups() {
        $('#MyCharacters').modal('hide');
    }
    function SubmitPost() {
        var strPostContent = $("#txtChatPostContent").val().trim();

        deactivateButton("#btnSubmitPost");
        if (strPostContent != '')
        {
            $.post("/Chat-Rooms/AddChatContent.aspx", { CharacterNameClass: $("#hdnCharacterNameClass").val(),
                CharacterDisplayName: $("#hdnCharacterDisplayName").val(),
                ChatRoomID: <%=ChatRoomID%>, 
                CharacterThumbnail: $("#hdnCharacterThumbnail").val(), 
                PostContent: strPostContent, 
                CharacterID: $("#hdnCurrentCharacterID").val(), 
                UserID: <%=UserID%>, 
                RatingID: <%=RatingID%> });
        }
        $("#txtChatPostContent").val('');
    }
    function GetPosts() {
        var currentTabID = $("ul#ChatRoomTabs li.active").prop("id");
     
        var ThePost = $.post("/Chat-Rooms/GetChatContent.aspx", { ChatRoomID: <%=ChatRoomID%>, UserID: <%=UserID%> });
        ThePost.done(function (data) {
            var ChatContent = $(data).find("#Content")[0].innerHTML;
            $("#ChatOutput").empty().html(ChatContent);
            if (initialLoad)
            {
                var ChatDetails = $(data).find("#ChatDescription")[0].innerHTML;
                $("#ChatRoomDetails").empty().html(ChatDetails);
                var ChatRooms = $(data).find("#ChatRoomsActive")[0].innerHTML;
                $(ChatRooms).insertAfter("#ChatRoomListTitle");          
                initialLoad = false;
            }
            linkifyStuff();
        })
        activateButton("#btnSubmitPost");
    }
    function GetChatRooms() {   
        var ThePost = $.post("/Chat-Rooms/GetChatContent.aspx", { ChatRoomID: <%=ChatRoomID%>, UserID: <%=UserID%> });
        ThePost.done(function (data) {
            var ChatRooms = $(data).find("#ChatRoomsActive")[0].innerHTML;
            $("#ChatRoomList").remove();             
            $(ChatRooms).insertAfter("#ChatRoomListTitle");          
        })         
    }
    function deactivateButton(theBtn) {
        $(theBtn).addClass("disabled");
        $(theBtn).prop('value', "Posting...");
        $(theBtn).prop("disabled", true);
    };
    function activateButton(theBtn) {
        $(theBtn).removeClass("disabled");
        $(theBtn).prop('value', "Submit Post");
        $(theBtn).prop("disabled", false);
    };
</script>
<div class="modal fade" id="ChatInfo" tabindex="-1" role="dialog" aria-labelledby="ChatInfoLabel" runat="server" clientidmode="Static">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="ChatInfoLabel">Chat Room Details</h4>
            </div>
            <div class="modal-body" style="max-height: 300px; overflow: auto;" id="ChatRoomDetails">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
